# Flutter Migration Architecture

## Quran Management & Memorization System

> Architecture decisions, rationale, and migration plan from WPF/.NET/SQL Server to Flutter

---

# Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Architecture Overview](#2-architecture-overview)
3. [State Management: Riverpod](#3-state-management-riverpod)
4. [Navigation: GoRouter](#4-navigation-gorouter)
5. [Local Database: drift (SQLite)](#5-local-database-drift-sqlite)
6. [Backend: .NET Web API](#6-backend-net-web-api)
7. [Offline-First Strategy](#7-offline-first-strategy)
8. [Data Sync Strategy](#8-data-sync-strategy)
9. [Authentication](#9-authentication)
10. [Folder Structure](#10-folder-structure)
11. [Design Patterns](#11-design-patterns)
12. [Model Mapping & DTOs](#12-model-mapping--dtos)
13. [Error Handling](#13-error-handling)
14. [Migration Plan](#14-migration-plan)
15. [Appendices](#15-appendices)

---

# 1. Executive Summary

## 1.1 Current State

The existing application is a Windows desktop (WPF) system using:
- **WPF** with WPF-UI component library
- **MVVM** via CommunityToolkit.Mvvm
- **SQL Server** via Entity Framework Core
- **BCrypt** for password hashing
- **HTML** for report generation

## 1.2 Target State

A cross-platform mobile/tablet application using:
- **Flutter** — single codebase for Android, iOS, and web
- **Riverpod** — state management with compile-time safety
- **drift** (SQLite) — local relational database
- **.NET Web API** — existing business logic exposed as REST API
- **SQL Server** — retained as backend database-of-record
- **JWT** — token-based authentication

## 1.3 Why Each Decision

| Decision | Rationale |
|---|---|
| **Flutter** | Single codebase for Android (primary tablet target) and iOS. Rich widget library with built-in RTL support. Strong Arabic text rendering. |
| **Riverpod** over Bloc | Simpler API, compile-time provider safety, no BuildContext dependency for logic, better testability with override support, built-in disposer mechanics. |
| **drift** over Hive/ObjectBox | The app has complex relational data (11 tables with FK relationships). drift is the only SQLite wrapper with type-safe queries, migrations, and DAO patterns. Hive is document-oriented and unsuitable for relational queries. |
| **.NET Web API backend** | The business logic (ProgressService, MemorizedRange overdue detection, KPI calculations, report generation) is complex and already proven. Rewriting all of it in Dart would introduce bugs and double maintenance. A .NET API wraps existing logic with zero rewrite. |
| **SQL Server retained** | The institution already has SQL Server. Migrating to a new database engine introduces migration risk for no benefit. SQL Server remains the source of truth; SQLite is the mobile cache. |
| **Offline-first** | Teachers use tablets in classrooms where internet may be unreliable. The app must function fully offline and sync when connected. |
| **JWT + BCrypt** | Existing BCrypt hashes remain on the server. JWT provides stateless authentication suitable for mobile clients. |

## 1.4 Principles

1. **Zero business logic rewrite** — all existing .NET logic is exposed via API, not reimplemented in Dart
2. **Offline-first** — the mobile app works fully without internet; sync is background and non-blocking
3. **RTL-first** — Arabic is the primary language; entire UI is Right-to-Left
4. **Incremental migration** — not a big-bang rewrite; feature-by-feature with coexistence period
5. **SQL Server stays** — no database migration; the existing DB is the source of truth

---

# 2. Architecture Overview

## 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        FLUTTER APP (Mobile/Tablet)                  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    PRESENTATION LAYER                        │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌────────────────────┐   │   │
│  │  │   Widgets    │  │  ViewModels │  │   State (Riverpod) │   │   │
│  │  │  (Screens)   │  │ (Notifiers) │  │    Providers       │   │   │
│  │  └─────────────┘  └─────────────┘  └────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                           │ uses                                    │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      DOMAIN LAYER                            │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌────────────────────┐   │   │
│  │  │   Entities   │  │  Use Cases  │  │  Repository       │   │   │
│  │  │  (Freezed)   │  │ (Services)  │  │  Interfaces       │   │   │
│  │  └─────────────┘  └─────────────┘  └────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                           │ implements                              │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                       DATA LAYER                             │   │
│  │  ┌─────────────────────┐  ┌──────────────────────────────┐   │   │
│  │  │  drift (Local DB)   │  │  API Client (Dio + REST)    │   │   │
│  │  │  SQLite tables      │  │  .NET Web API Consumer      │   │   │
│  │  └─────────────────────┘  └──────────────────────────────┘   │   │
│  │  ┌──────────────────────────────────────────────────────┐   │   │
│  │  │  Sync Engine (background isolate)                    │   │   │
│  │  └──────────────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                              │ HTTP / WSS
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     .NET WEB API (Backend)                          │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Controllers  →  Application Services  →  EF Core → SQL    │   │
│  │  JWT Auth         (Existing business logic)      Server     │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Existing Services wrapped: AuthService, StudentService,    │   │
│  │  SessionService, ScheduleService, GoalService,              │   │
│  │  ProgressService, MemorizedRangeService, DashboardService,  │   │
│  │  ReportService                                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## 2.2 Layer Responsibilities

| Layer | Responsibility | Technology |
|---|---|---|
| **Presentation** | UI rendering, user input, state-driven rebuilds | Flutter widgets, Riverpod notifiers/providers |
| **Domain** | Business entities, use cases, repository contracts | Pure Dart classes, Freezed models |
| **Data** | Data source orchestration (local + remote), sync logic | drift (SQLite), Dio (HTTP), Sync Engine |
| **Backend** | Business logic execution, data persistence, auth | .NET 8 Web API, EF Core, SQL Server |

## 2.3 Data Flow Pattern

```
User Action → Widget → Riverpod Notifier → Repository → Data Source
                                                           ├── Local (drift)
                                                           └── Remote (API)
                                        ┌──────────────────────┘
                                        ▼
                              Sync Engine (background)
                              keeps local DB in sync
```

---

# 3. State Management: Riverpod

## 3.1 Provider Types Used

| Provider Type | Purpose | Example |
|---|---|---|
| `Provider` | Read-only dependency injection | `apiClientProvider`, `databaseProvider` |
| `FutureProvider` | Async single-shot data | `surahsProvider`, `studentsProvider` |
| `StreamProvider` | Reactive real-time data | `connectivityProvider` |
| `StateNotifierProvider` | Mutable state with logic | `sessionCreateProvider`, `studentListProvider` |
| `AsyncNotifierProvider` | Async mutable state | `dashboardProvider`, `syncStatusProvider` |
| `FamilyProvider` | Parameterized state | `studentDetailsProvider(studentId)` |

## 3.2 Why Riverpod over Bloc

| Criterion | Riverpod | Bloc |
|---|---|---|
| Compile-time safety | ✅ Providers are compile-time checked | ❌ Events/States are strings/runtime |
| No BuildContext needed | ✅ Read providers from anywhere | ❌ Requires context for BlocProvider |
| Testability | ✅ Override any provider in test | ✅ Fair (needs BlocProvider tree) |
| Boilerplate | ✅ Minimal | ❌ 3 files per feature (Event/State/Bloc) |
| Learning curve | ✅ Medium | ❌ Steep (events, states, transitions) |
| dispose/autodispose | ✅ Automatic via ref.onDispose | ❌ Manual close handling |

## 3.3 Dependency Injection

Riverpod **is** the DI container. No external DI library needed.

```dart
// No manual DI registration; providers are declared and compose naturally:

// External dependencies
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(ref.watch(dioProvider)));
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// Repositories
final studentRepositoryProvider = Provider<StudentRepository>((ref) => StudentRepositoryImpl(
  localDataSource: ref.watch(localStudentDataSourceProvider),
  remoteDataSource: ref.watch(remoteStudentDataSourceProvider),
  syncEngine: ref.watch(syncEngineProvider),
));

// Use cases
final getStudentsProvider = Provider<GetStudents>((ref) => GetStudents(ref.watch(studentRepositoryProvider)));

// State
final studentListProvider = AsyncNotifierProvider<StudentListNotifier, List<Student>>(() => StudentListNotifier());
```

---

# 4. Navigation: GoRouter

## 4.1 Route Structure

```
/                                 → Dashboard
/login                            → Login
/setup                            → First-time admin setup
/students                         → Student list
/students/create                  → Student create form
/students/:id                     → Student details (tabs)
/students/:id/edit                → Student edit form
/students/:id/sessions/create     → Session create
/students/:id/sessions/:sid/edit  → Session edit
/students/:id/schedules/create    → Schedule create
/students/:id/goals/create        → Goal create
/sessions                         → Sessions list (with filters as query params)
/attendance                       → Attendance list
/goals                            → Goals list
/reports                          → Reports
/settings                         → Settings (admin only)
```

## 4.2 Why GoRouter

- **Declarative** routing similar to Flutter Navigator 2.0
- **Deep linking** support for push notifications
- **Redirect guards** for authentication (unauthenticated → /login)
- **Nested navigation** for tab-based screens (student details: info tab vs memorization tab)
- **Type-safe parameters** (no string parsing for route params)

```dart
GoRouter(
  redirect: (context, state) {
    final isLoggedIn = ref.read(authProvider).isLoggedIn;
    final isSetup = ref.read(authProvider).isFirstRun;
    if (!isLoggedIn && state.matchedLocation != '/login' && state.matchedLocation != '/setup') return '/login';
    if (isSetup && state.matchedLocation != '/setup') return '/setup';
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/setup', builder: (_, __) => const SetupScreen()),
    // ... etc
  ],
);
```

---

# 5. Local Database: drift (SQLite)

## 5.1 Why drift

| Feature | Need | drift Support |
|---|---|---|
| Relational (FKs, joins) | 11 tables with complex relationships | ✅ Type-safe joins, foreign keys |
| Migrations | Schema changes over time | ✅ Versioned migration system |
| DAO pattern | Clean separation of queries | ✅ DAO classes per entity group |
| Type safety | Compile-time query checking | ✅ Generated code |
| Stream queries | Reactive UI updates on DB change | ✅ `watch()` returns Stream |
| Batch operations | Sync inserts/updates | ✅ Batch support |
| Custom SQL | Complex reporting queries | ✅ Raw SQL with type-safe mapping |

## 5.2 Entity Mapping (WPF → drift)

Each WPF entity maps to a drift table with **the same schema** (minus SQL Server specific features):

```dart
// drift table definition
class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text().withLength(max: 100)();
  IntColumn get age => integer()();
  TextColumn get phone => text()();
  TextColumn get address => text()();
  TextColumn? get parentName => text().withLength(max: 100).nullable()();
  TextColumn? get parentPhone => text().nullable()();
  IntColumn? get currentSurahId => integer().nullable()();
  IntColumn? get lastCompletedSurahId => integer().nullable()();
  IntColumn get totalCompletedJuz => integer().withDefault(const Constant(0))();
  TextColumn get level => text().withDefault(const Constant("مبتدئ"))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

## 5.3 Drift Local Only — SQL Server Remains Source of Truth

The drift database is a **local cache**, not a primary store:
- Schema mirrors SQL Server tables exactly
- All data is synced from SQL Server via the API
- Local writes are queued for sync to the server
- Read operations always hit local drift first (offline-first)

---

# 6. Backend: .NET Web API

## 6.1 Why Keep a .NET Backend

The existing application has **complex business logic** that is proven and tested:

| Service | Logic Complexity | Lines | Rewrite Risk |
|---|---|---|---|
| `ProgressService.SyncStudentProgressAsync` | Multi-step: surah detection, juz calculation, level assignment, goal sync | ~60 | High |
| `ProgressService.CalculateCompletedJuzAsync` | 30 juz × 124 ranges mapping with mem-checking | ~40 | High |
| `MemorizedRangeService.GetByStudentAsync` | Overdue detection + auto-status flip | ~30 | Medium |
| `DashboardService.GetDashboardDataAsync` | 12+ KPI calculations in one query batch | ~80 | High |
| `ReportService` | 4 report types with HTML generation | ~150 | High |
| `BackupService` | JSON serialization + GZip + full restore | ~80 | High |

**Total business logic lines: ~440 lines of complex C# code.** Rewriting in Dart would:
1. Duplicate logic in two languages (maintenance burden)
2. Introduce bugs in translation
3. Split the truth (which version is correct?)

**Instead: Wrap existing logic in REST API endpoints.**

## 6.2 API Endpoints

### Authentication

| Method | Path | Body | Response |
|---|---|---|---|
| GET | `/api/auth/any-users` | — | `{ exists: bool }` |
| POST | `/api/auth/login` | `{ username, password }` | `{ token, user }` |
| POST | `/api/auth/setup` | `{ username, password, fullName }` | `{ token, user }` |

### Students

| Method | Path | Params/Body | Response |
|---|---|---|---|
| GET | `/api/students` | `?search=` | `Student[]` |
| GET | `/api/students/{id}` | — | `Student` (fully included) |
| POST | `/api/students` | `Student` | `Student` |
| PUT | `/api/students/{id}` | `Student` | `Student` |
| DELETE | `/api/students/{id}` | — | `204` |

### Sessions

| Method | Path | Params/Body | Response |
|---|---|---|---|
| GET | `/api/sessions` | `?studentId=&from=&to=` | `Session[]` |
| GET | `/api/sessions/{id}` | — | `Session` |
| POST | `/api/sessions` | `Session` | `Session` (triggers Progress sync) |
| PUT | `/api/sessions/{id}` | `Session` | `Session` |
| DELETE | `/api/sessions/{id}` | — | `204` |

### Schedules

| Method | Path | Body | Response |
|---|---|---|---|
| GET | `/api/schedules/upcoming` | `?studentId=` | `Schedule[]` |
| GET | `/api/schedules/{id}` | — | `Schedule` |
| POST | `/api/schedules` | `Schedule` | `Schedule` |
| DELETE | `/api/schedules/{id}` | — | `204` |
| POST | `/api/schedules/{id}/convert` | — | `Session` |

### Goals

| Method | Path | Body | Response |
|---|---|---|---|
| GET | `/api/goals` | `?studentId=&status=` | `Goal[]` |
| POST | `/api/goals` | `Goal` | `Goal` |
| DELETE | `/api/goals/{id}` | — | `204` |

### Memorized Ranges

| Method | Path | Body | Response |
|---|---|---|---|
| GET | `/api/memorized-ranges/{studentId}` | — | `MemorizedRange[]` (triggers overdue detection) |
| POST | `/api/memorized-ranges` | `MemorizedRange` | `MemorizedRange` |
| PUT | `/api/memorized-ranges/{id}` | `MemorizedRange` | `MemorizedRange` |
| DELETE | `/api/memorized-ranges/{id}` | — | `204` |
| POST | `/api/memorized-ranges/{id}/mark-revised` | — | `MemorizedRange` |

### Dashboard

| Method | Path | Response |
|---|---|---|
| GET | `/api/dashboard` | `DashboardData` |

### Reports

| Method | Path | Params | Response |
|---|---|---|---|
| GET | `/api/reports/student` | `?studentId=&from=&to=` | `text/html` |
| GET | `/api/reports/attendance` | `?from=&to=` | `text/html` |
| GET | `/api/reports/progress` | `?from=&to=` | `text/html` |
| GET | `/api/reports/evaluation` | `?from=&to=` | `text/html` |

### Sync

| Method | Path | Body | Response |
|---|---|---|---|
| POST | `/api/sync/pull` | `{ lastSyncTimestamp }` | `{ students, sessions, schedules, goals, memorizedRanges }` |
| POST | `/api/sync/push` | `{ changes[] }` | `{ conflicts[], serverVersion[] }` |

## 6.3 API Client Layer (Flutter)

```dart
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(RetryInterceptor(dio: _dio, retries: 2));
    _dio.interceptors.add(LogInterceptor(requestBody: true));
  }

  // Typed methods, no manual JSON parsing
  Future<List<Student>> getStudents({String? search}) async { ... }
  Future<Student> getStudent(int id) async { ... }
  Future<Session> createSession(SessionDto dto) async { ... }
  // etc.
}
```

---

# 7. Offline-First Strategy

## 7.1 Architecture

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────┐
│  User Action  │────▶│   Repository     │────▶│  Local (drift)│
└──────────────┘     │  (orchestrator)   │     └──────┬───────┘
                     └────────┬─────────┘            │
                              │                      │ sync queue
                              ▼                      ▼
                     ┌──────────────────┐     ┌──────────────┐
                     │   API (remote)    │     │  Sync Engine │
                     └──────────────────┘     └──────────────┘
```

## 7.2 Read Strategy (Offline-First)

```
Repository.getStudents():
  1. Return stream from local drift DB (always)
  2. If online, trigger background API fetch
  3. API response → upsert into local drift
  4. UI rebuilds automatically via drift stream
```

## 7.3 Write Strategy (Local-First)

```
Repository.createSession(session):
  1. Generate local UUID (not relying on server ID yet)
  2. Insert into local drift with pending_sync=true
  3. Return to UI immediately (optimistic update)
  4. Queue for sync in pending_changes table
  5. Sync engine sends to API when online
  6. On success: update local record with server ID, clear pending_sync
  7. On conflict: surface to user for resolution
```

## 7.4 Pending Changes Table

```sql
CREATE TABLE pending_changes (
  id INTEGER PRIMARY KEY,
  entity_type TEXT NOT NULL,      -- 'session', 'student', etc.
  entity_local_id INTEGER NOT NULL,
  operation TEXT NOT NULL,         -- 'create', 'update', 'delete'
  payload JSON NOT NULL,           -- full serialized entity
  created_at TEXT NOT NULL,
  retry_count INTEGER DEFAULT 0,
  last_error TEXT
);
```

## 7.5 Why Offline-First

- Teachers use the app in classrooms — often without reliable internet
- Session recording must be instant, no loading spinners
- Data integrity is maintained via local SQLite + sync queue
- Sync is eventually consistent — acceptable for this domain (no real-time needs)

---

# 8. Data Sync Strategy

## 8.1 Sync Model: Timestamp-Based Incremental

Each entity has a `updatedAt` timestamp. The sync tracks the last successful sync time.

### Pull (Server → Local)

```
Client: POST /api/sync/pull { lastSyncTimestamp: "2026-06-20T10:00:00Z" }
Server: Return all entities with updatedAt > lastSyncTimestamp
Client: Upsert all returned entities into local drift
Client: Update lastSyncTimestamp
```

### Push (Local → Server)

```
Client: Read all records from pending_changes table
Client: POST /api/sync/push { changes: [ { entity, operation, payload, localId } ] }
Server: Process each change
  - create: Insert → return server ID
  - update: Apply → check for conflicts (server updatedAt > client baseTimestamp)
  - delete: Remove → verify exists
Server: Return { results: [ { localId, serverId, status, conflict? } ] }
Client: On success → clear pending_changes entry, update local ID mapping
Client: On conflict → surface to user (server version wins by default)
```

## 8.2 Conflict Resolution Strategy

**Server-wins by default** with notification:

| Scenario | Resolution |
|---|---|
| Same field edited on both sides | Server timestamp wins → user notified of override |
| Delete on server, update on client | Server delete wins → client change discarded, user notified |
| Delete on client, update on server | Client delete wins → server change discarded |
| Concurrent creates (same local ID) | Server detects by unique constraint → returns server ID, user notified |

## 8.3 Sync Triggers

| Trigger | Action |
|---|---|
| App comes to foreground | Pull + Push |
| Periodic (every 5 min when online) | Pull + Push |
| After local write | Push (immediate if online) |
| Manual pull-to-refresh | Pull + Push |
| Connectivity restored | Pull + Push |

## 8.4 Connectivity Awareness

```dart
final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map(
    (result) => result != ConnectivityResult.none,
  );
});
```

---

# 9. Authentication

## 9.1 Flow

```
[First run — no users in SQL Server]
  Setup Screen → POST /api/auth/setup { username, password, fullName }
  → Server creates Admin user with BCrypt hash
  → Returns JWT token + user info
  → Flutter stores token in flutter_secure_storage
  → Navigate to Dashboard

[Subsequent runs]
  Login Screen → POST /api/auth/login { username, password }
  → Server verifies BCrypt hash
  → Returns JWT token + user info + role
  → Flutter stores token
  → Navigate to Dashboard
```

## 9.2 JWT Strategy

- **Token lifetime**: 24 hours (configurable)
- **Refresh mechanism**: Silent refresh using refresh token or re-login on 401
- **Storage**: `flutter_secure_storage` (Keychain on iOS, EncryptedSharedPreferences on Android)
- **Role claim**: Embedded in JWT as `role: "Admin" | "Teacher"`
- **Authorization**: API validates role on admin endpoints (settings, user management)

## 9.3 Authentication State in Flutter

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated({required User user, required String token}) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.firstRun() = _FirstRun; // No users exist → show setup
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
```

## 9.4 Why JWT over Session-Based

- **Stateless**: Server doesn't need session storage
- **Mobile-friendly**: Token stored on device, sent with each request
- **Expiration**: Built-in expiry mechanism
- **No cookie management**: Flutter handles tokens explicitly, not HTTP cookies
- **Works offline**: Token can be verified locally (expiry check) for UI decisions

---

# 10. Folder Structure

## 10.1 Top-Level

```
lib/
├── main.dart
├── app.dart                          # MaterialApp with GoRouter
├── bootstrap.dart                    # Initialization (database, etc.)
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart        # Base URL, timeouts
│   │   ├── app_constants.dart        # App-wide constants
│   │   └── db_constants.dart         # Table names, defaults
│   ├── enums/
│   │   ├── attendance_status.dart
│   │   ├── goal_status.dart
│   │   ├── goal_type.dart
│   │   ├── memorized_status.dart
│   │   ├── student_level.dart
│   │   └── user_role.dart
│   ├── errors/
│   │   ├── app_error.dart            # Base error class
│   │   ├── api_error.dart            # HTTP error mapping
│   │   └── sync_error.dart           # Sync conflict errors
│   ├── network/
│   │   ├── api_client.dart           # Dio instance factory
│   │   ├── auth_interceptor.dart     # JWT injection
│   │   ├── retry_interceptor.dart    # Auto-retry on failure
│   │   └── connectivity_provider.dart
│   ├── theme/
│   │   ├── app_theme.dart            # ThemeData with RTL
│   │   ├── app_colors.dart           # Color palette
│   │   ├── app_text_styles.dart      # Typography
│   │   └── widgets/                  # Shared widgets
│   │       ├── status_badge.dart
│   │       ├── kpi_card.dart
│   │       ├── session_card.dart
│   │       ├── loading_overlay.dart
│   │       └── error_banner.dart
│   ├── utils/
│   │   ├── date_utils.dart           # Arabic date formatting
│   │   ├── quran_utils.dart          # Ayah count, surah helpers
│   │   └── grade_utils.dart          # Score → Arabic grade
│   └── router/
│       ├── app_router.dart           # GoRouter configuration
│       └── route_names.dart          # Route name constants
│
├── data/
│   ├── local/
│   │   ├── database/
│   │   │   ├── app_database.dart     # drift database definition
│   │   │   ├── app_database.g.dart   # Generated
│   │   │   ├── tables/
│   │   │   │   ├── students_table.dart
│   │   │   │   ├── sessions_table.dart
│   │   │   │   ├── sessions_memorizations_table.dart
│   │   │   │   ├── sessions_revisions_table.dart
│   │   │   │   ├── sessions_evaluations_table.dart
│   │   │   │   ├── schedules_table.dart
│   │   │   │   ├── goals_table.dart
│   │   │   │   ├── memorized_ranges_table.dart
│   │   │   │   ├── surahs_table.dart
│   │   │   │   ├── juz_surah_ranges_table.dart
│   │   │   │   ├── users_table.dart
│   │   │   │   └── pending_changes_table.dart
│   │   │   └── daos/
│   │   │       ├── student_dao.dart
│   │   │       ├── session_dao.dart
│   │   │       ├── schedule_dao.dart
│   │   │       ├── goal_dao.dart
│   │   │       ├── memorized_range_dao.dart
│   │   │       └── sync_dao.dart
│   │   └── data_sources/
│   │       ├── local_student_data_source.dart
│   │       ├── local_session_data_source.dart
│   │       ├── local_schedule_data_source.dart
│   │       └── ...
│   ├── remote/
│   │   ├── data_sources/
│   │   │   ├── remote_student_data_source.dart
│   │   │   ├── remote_session_data_source.dart
│   │   │   ├── remote_schedule_data_source.dart
│   │   │   ├── remote_goal_data_source.dart
│   │   │   ├── remote_memorized_range_data_source.dart
│   │   │   ├── remote_dashboard_data_source.dart
│   │   │   └── remote_auth_data_source.dart
│   │   └── dtos/
│   │       ├── student_dto.dart
│   │       ├── session_dto.dart
│   │       ├── schedule_dto.dart
│   │       ├── goal_dto.dart
│   │       ├── memorized_range_dto.dart
│   │       ├── dashboard_dto.dart
│   │       └── auth_dto.dart
│   ├── repositories/
│   │   ├── student_repository_impl.dart
│   │   ├── session_repository_impl.dart
│   │   ├── schedule_repository_impl.dart
│   │   ├── goal_repository_impl.dart
│   │   ├── memorized_range_repository_impl.dart
│   │   ├── dashboard_repository_impl.dart
│   │   └── auth_repository_impl.dart
│   └── sync/
│       ├── sync_engine.dart          # Background sync orchestrator
│       ├── sync_queue.dart           # Pending changes manager
│       ├── sync_conflict_resolver.dart
│       └── sync_providers.dart
│
├── domain/
│   ├── entities/
│   │   ├── student.dart              # Freezed model
│   │   ├── session.dart
│   │   ├── schedule.dart
│   │   ├── goal.dart
│   │   ├── memorized_range.dart
│   │   ├── surah.dart
│   │   ├── user.dart
│   │   └── dashboard_data.dart
│   ├── repositories/
│   │   ├── student_repository.dart   # Abstract interface
│   │   ├── session_repository.dart
│   │   ├── schedule_repository.dart
│   │   ├── goal_repository.dart
│   │   ├── memorized_range_repository.dart
│   │   ├── dashboard_repository.dart
│   │   └── auth_repository.dart
│   └── use_cases/
│       ├── get_students.dart
│       ├── create_session.dart
│       ├── sync_student_progress.dart
│       └── ...
│
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── setup_screen.dart
│   │   └── widgets/
│   │       └── login_form.dart
│   ├── dashboard/
│   │   ├── providers/
│   │   │   └── dashboard_provider.dart
│   │   ├── screens/
│   │   │   └── dashboard_screen.dart
│   │   └── widgets/
│   │       ├── kpi_card_widget.dart
│   │       ├── weekly_chart.dart
│   │       └── top_students_list.dart
│   ├── students/
│   │   ├── providers/
│   │   │   ├── student_list_provider.dart
│   │   │   └── student_details_provider.dart
│   │   ├── screens/
│   │   │   ├── student_list_screen.dart
│   │   │   ├── student_details_screen.dart
│   │   │   ├── student_create_screen.dart
│   │   │   └── student_edit_screen.dart
│   │   └── widgets/
│   │       ├── student_card.dart
│   │       └── student_info_section.dart
│   ├── sessions/
│   │   ├── providers/
│   │   │   ├── session_list_provider.dart
│   │   │   ├── session_create_provider.dart
│   │   │   └── session_edit_provider.dart
│   │   ├── screens/
│   │   │   ├── sessions_list_screen.dart
│   │   │   ├── session_create_screen.dart
│   │   │   └── session_edit_screen.dart
│   │   └── widgets/
│   │       ├── attendance_selector.dart
│   │       ├── memorization_section.dart
│   │       ├── revision_section.dart
│   │       └── evaluation_section.dart
│   ├── schedules/
│   │   ├── providers/
│   │   │   └── schedule_provider.dart
│   │   ├── screens/
│   │   │   └── schedule_create_screen.dart
│   │   └── widgets/
│   │       └── schedule_form.dart
│   ├── goals/
│   │   ├── providers/
│   │   │   └── goal_provider.dart
│   │   ├── screens/
│   │   │   ├── goals_list_screen.dart
│   │   │   └── goal_create_screen.dart
│   │   └── widgets/
│   │       └── goal_card.dart
│   ├── memorization/
│   │   ├── providers/
│   │   │   └── memorized_range_provider.dart
│   │   ├── screens/
│   │   │   └── memorization_screen.dart
│   │   └── widgets/
│   │       ├── range_card.dart
│   │       └── range_form.dart
│   ├── attendance/
│   │   ├── providers/
│   │   │   └── attendance_provider.dart
│   │   ├── screens/
│   │   │   └── attendance_screen.dart
│   │   └── widgets/
│   │       ├── attendance_filter.dart
│   │       └── attendance_row.dart
│   └── reports/
│       ├── providers/
│       │   └── report_provider.dart
│       ├── screens/
│       │   └── report_screen.dart
│       └── widgets/
│           ├── report_filter_panel.dart
│           └── report_result_card.dart
│
├── generated/                        # Freezed / json_serializable generated code
└── providers.dart                    # Barrel file for all top-level providers
```

## 10.2 File Naming Conventions

| Pattern | Example |
|---|---|
| `snake_case` files | `student_repository.dart` |
| `PascalCase` classes | `class StudentRepository` |
| `_screen` suffix for screens | `login_screen.dart` → `LoginScreen` |
| `_widget` suffix for widgets | `kpi_card_widget.dart` → `KpiCardWidget` |
| `_provider` suffix for providers | `auth_provider.dart` |
| `_dto` suffix for DTOs | `student_dto.dart` |
| `_dao` suffix for drift DAOs | `student_dao.dart` |
| `_table` suffix for drift tables | `students_table.dart` |

---

# 11. Design Patterns

## 11.1 Repository Pattern

Every data operation goes through a Repository interface:

```dart
// Domain layer — pure contract
abstract class StudentRepository {
  Stream<List<Student>> watchAll({String? search}); // Reactive stream from local DB
  Future<Student> getById(int id);
  Future<Student> create(Student student);
  Future<Student> update(Student student);
  Future<void> delete(int id);
}

// Data layer — implementation
class StudentRepositoryImpl implements StudentRepository {
  final LocalStudentDataSource _local;
  final RemoteStudentDataSource _remote;
  final SyncEngine _syncEngine;

  @override
  Stream<List<Student>> watchAll({String? search}) {
    // Always returns local DB stream (offline-first)
    return _local.watchAll(search: search);
  }

  @override
  Future<Student> create(Student student) async {
    final localId = await _local.insert(student.copyWithIsSynced(false));
    await _syncEngine.enqueue(SyncChange('student', localId, 'create', student));
    return student.copyWith(id: localId);
  }
}
```

## 11.2 Riverpod Provider Pattern

```dart
// Public state exposed to UI
final studentListProvider = AsyncNotifierProvider<StudentListNotifier, List<Student>>(() {
  return StudentListNotifier();
});

// Notifier handles business logic + orchestration
class StudentListNotifier extends AsyncNotifier<List<Student>> {
  @override
  Future<List<Student>> build() async {
    final repo = ref.read(studentRepositoryProvider);
    return repo.watchAll().first; // Initial load
  }

  Future<void> refresh() async { ... }
  Future<Student> create(Student student) async { ... }
  Future<void> delete(int id) async { ... }
}
```

## 11.3 Freezed for Immutable Models

All entities use `@freezed` for immutability, equality, copyWith, and JSON serialization:

```dart
@freezed
class Student with _$Student {
  const factory Student({
    @Default(0) int id,
    required String fullName,
    required int age,
    String phone = '',
    String address = '',
    String? parentName,
    String? parentPhone,
    int? currentSurahId,
    int? lastCompletedSurahId,
    @Default(0) int totalCompletedJuz,
    @Default('مبتدئ') String level,
    @Default(false) bool isSynced,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);
}
```

## 11.4 Drift DAO Pattern

```dart
@drift
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
  StudentDao(AppDatabase db) : super(db);

  Stream<List<Student>> watchAll({String? search}) {
    return (select(students)..where((s) => s.fullName.contains(search ?? ''))).watch();
  }

  Future<int> insert(Student student) => into(students).insert(student.toDriftCompanion());
  Future<void> update(Student student) => update(students).replace(student);
  Future<void> delete(int id) => (delete(students)..where((s) => s.id.equals(id))).go();
}
```

## 11.5 Why These Patterns

| Pattern | Purpose |
|---|---|
| **Repository** | Abstracts data sources; testable with mock repos; allows offline-first switching between local/remote |
| **Provider** | Inversion of control without DI framework; compile-time safe; auto-disposal |
| **Freezed** | Immutability prevents state mutation bugs; `copyWith` enables immutable updates; JSON serialization for free |
| **DAO** | Type-safe SQL queries; reactive streams for automatic UI updates; migration management |

---

# 12. Model Mapping & DTOs

## 12.1 Three-Layer Model Architecture

```
┌───────────────┐     ┌──────────────┐     ┌───────────────┐
│  JSON (API)    │────▶│  DTO         │────▶│  Domain       │
│  Server format  │     │  (freezed)   │     │  Entity       │
└───────────────┘     └──────────────┘     │  (freezed)     │
                                           └───────────────┘
                                                  │
                                                  ▼
                                           ┌───────────────┐
                                           │  Drift Row     │
                                           │  (local DB)    │
                                           └───────────────┘
```

## 12.2 Mapping Flow

```
API JSON → `StudentDto.fromJson(json)` → `dto.toEntity()` → `Student` (domain)
Local DB row → `DriftStudent` (generated) → manual mapping → `Student` (domain)
Domain `Student` → `student.toDriftCompanion()` → insert into local DB
Domain `Student` → `StudentDto.fromEntity(student)` → `dto.toJson()` → API request
```

## 12.3 Why Three Separate Models

| Model | Purpose | Why Separate |
|---|---|---|
| **DTO** | Wire format matching server JSON | Server may use different field names (camelCase vs snake_case), nullable fields for partial updates |
| **Domain Entity** | Pure business object | No serialization concerns, no DB concerns, clean use-case logic |
| **Drift Row** | Database row representation | drift's generated code uses `Companion` pattern for inserts; nullable fields for auto-increment IDs |

---

# 13. Error Handling

## 13.1 Error Hierarchy

```dart
@freezed
sealed class AppError with _$AppError {
  const factory AppError.api({
    required int statusCode,
    required String message,
    String? field,
  }) = ApiError;

  const factory AppError.network({
    required String message,
    bool isRetryable,
  }) = NetworkError;

  const factory AppError.database({
    required String message,
    required String operation,
  }) = DatabaseError;

  const factory AppError.sync({
    required String entityType,
    required int localId,
    required String message,
    SyncConflict? conflict,
  }) = SyncError;

  const factory AppError.validation({
    required String message,
    required Map<String, String> fieldErrors,
  }) = ValidationError;

  const factory AppError.unknown({
    required String message,
    Object? originalError,
  }) = UnknownError;
}
```

## 13.2 Error Handling Strategy

- **Repositories** catch all errors and wrap in `AppError` types
- **Providers/Notifiers** surface errors via `AsyncValue.error()`
- **Widgets** use `.when()` on `AsyncValue` to show loading/data/error states
- **Unhandled errors** are caught by `FlutterError.onError` and logged via `log()` and optionally sent to server
- **Network errors** trigger retry (max 3 with exponential backoff) via `RetryInterceptor`
- **Sync errors** are stored in `pending_changes.last_error` and retried on next sync cycle
- **Validation errors** from API (400 Bad Request) are surfaced as field-level errors in forms

```dart
// Widget pattern
ref.watch(studentListProvider).when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stack) => ErrorBanner(message: error.toString()),
  data: (students) => ListView.builder(itemCount: students.length, ...),
);
```

---

# 14. Migration Plan

## 14.1 Phase 0: Foundation (Weeks 1-2)

### Tasks
1. **Create .NET Web API project**
   - New `QM.API` project in existing solution
   - Controllers for each entity (Students, Sessions, etc.)
   - JWT authentication middleware
   - Swagger/OpenAPI documentation

2. **Seed data API**
   - `/api/surahs` — returns all 114 surahs
   - `/api/juz-ranges` — returns 124 range entries
   - Critical for mobile app initialization

3. **Dockerize SQL Server** (optional)
   - Docker Compose for local development with SQL Server container

### Deliverables
- Running .NET Web API with Swagger UI
- Authentication working (login, setup, JWT)
- Student CRUD endpoints working
- GitHub Actions CI for API

## 14.2 Phase 1: Flutter Foundation (Weeks 3-4)

### Tasks
1. **Flutter project scaffold**
   - Riverpod setup
   - GoRouter configuration
   - drift database with all 11 tables
   - Dio API client with auth interceptor
   - RTL theme with Arabic typography

2. **Authentication flow**
   - Login screen + Provider
   - Setup screen (first-run admin creation)
   - Token storage and JWT injection
   - Auth guard in GoRouter

3. **Seed data sync**
   - First launch downloads surahs + juz ranges from API
   - Stores in local drift
   - Progress indicator during initial sync

### Deliverables
- Running Flutter app with login/setup
- Dashboard screen showing KPIs from API
- Offline: can show cached dashboard data

## 14.3 Phase 2: Core Features (Weeks 5-8)

### Tasks
1. **Student management** (parallel)
   - Student list with search
   - Student create/edit forms
   - Student details screen (info + statistics)
   - Offline-first with local DB + background sync

2. **Session management** (parallel)
   - Session create with memorization + revision + evaluation
   - Session edit
   - Sessions list with filters (Today/Week/All/Upcoming)
   - Schedule create
   - Schedule → Session conversion flow

3. **Goal management** (parallel)
   - Goal create (Surah/Juz type)
   - Goals list with status filtering
   - Goal progress display on student profile

4. **Memorization tracking** (parallel)
   - Three-group card layout (Memorized/Needs Revision/Not Memorized)
   - Add/edit/delete range
   - Mark as revised
   - Overdue detection (triggered via API)

### Deliverables
- Complete student profile with sessions, schedules, goals
- Session CRUD with all evaluation fields
- Schedule management with convert-to-session
- Memorized range cards

## 14.4 Phase 3: Dashboard & Reports (Weeks 9-10)

### Tasks
1. **Dashboard screen**
   - KPI cards (total students, today's sessions, attendance %)
   - Top 5 students by evaluation score
   - Weekly attendance chart (last 7 days)
   - Links to major features

2. **Attendance screen**
   - Filterable attendance list (search + date range)
   - Attendance statistics (present/absent/excused/late)
   - Student navigation from attendance rows

3. **Reports screen**
   - Report type selection (5 types)
   - Date range + student filters
   - Inline HTML rendering via `flutter_widget_from_html` or `webview_flutter`
   - Share/export functionality

### Deliverables
- Fully functional dashboard with real data
- Attendance tracking with filters
- Report viewing and sharing

## 14.5 Phase 4: Sync & Offline (Week 11)

### Tasks
1. **Sync engine**
   - Background pull/push with periodic timer
   - Pending changes queue management
   - Conflict resolution UI
   - Sync status indicator in app bar

2. **Connectivity awareness**
   - Offline banner when disconnected
   - Graceful degradation (read-only when offline)
   - Queue visualization (pending changes count)

3. **Initial data bootstrap**
   - First-run download of all reference data
   - Incremental sync thereafter

### Deliverables
- Full offline functionality
- Seamless background sync
- Sync status visible to user

## 14.6 Phase 5: Settings & Admin (Week 12)

### Tasks
1. **Settings screen**
   - Admin-only access (role-gated)
   - Create teacher account
   - Database backup (API trigger)
   - Database restore (with confirmation)

2. **Admin-specific features**
   - Teacher list management

### Deliverables
- Complete settings functionality
- Admin role enforcement

## 14.7 Phase 6: Polish & Release (Weeks 13-14)

### Tasks
1. **UI polish**
   - Loading animations
   - Empty states
   - Error states
   - Pull-to-refresh throughout
   - Arabic typography refinement
   - Tablet-optimized layout (split pane)

2. **Performance**
   - Profile and optimize
   - Lazy load session lists (pagination)
   - Image/asset optimization

3. **Testing**
   - Unit tests (repositories, use cases)
   - Widget tests (critical screens)
   - Integration tests (auth flow, session create)
   - Manual QA on Android tablet

4. **Release preparation**
   - Android app bundle (APK/AAB)
   - iOS TestFlight (if needed)
   - Documentation update
   - User training materials

### Deliverables
- Release-ready mobile application
- Test coverage for critical paths
- User documentation

## 14.8 Phase 7: Coexistence & Cutover (Week 15)

### Tasks
1. **Dual-running period**
   - Both WPF desktop and Flutter mobile app run simultaneously
   - Both point to same SQL Server database via API
   - No separate data islands

2. **User acceptance testing**
   - Teachers use mobile app for daily sessions
   - Admin uses desktop for reports and settings
   - Collect feedback

3. **Desktop retirement planning**
   - Identify any gaps
   - Plan desktop feature freeze
   - Schedule desktop decommission

### Deliverables
- Both apps running on same database
- UAT sign-off
- Desktop retirement plan

## 14.9 Migration Risk Matrix

| Risk | Impact | Likelihood | Mitigation |
|---|---|---|---|
| Sync conflicts corrupt data | High | Low | Server-wins strategy + conflict logging |
| Offline changes lost | High | Low | Persistent pending_changes queue with retry |
| API performance with many concurrent mobile clients | Medium | Low | API caching layer, pagination for lists |
| Learning curve for Riverpod/drift | Medium | Medium | Pair programming, code review, documentation |
| Arabic RTL rendering issues | Medium | Low | Test on actual device early; Flutter RTL is mature |
| SQL Server → drift schema drift | Medium | Medium | Automated schema comparison in CI |
| User resistance to mobile | Medium | Medium | Training sessions, coexist period, desktop fallback |

---

# 15. Appendices

## 15.1 Comparison: WPF Stack vs Flutter Stack

| Layer | WPF (.NET) | Flutter | Migration Strategy |
|---|---|---|---|
| UI Framework | WPF + WPF-UI | Flutter widgets | Complete rewrite (no sharing possible) |
| Architecture | MVVM + Clean Architecture | MVVM + Clean Architecture | Same pattern, different language |
| State Mgmt | CommunityToolkit.Mvvm | Riverpod | Conceptual mapping per feature |
| DI | Microsoft.Extensions.DI | Riverpod providers | Replace service locator with Riverpod |
| Local DB | None (always online) | drift (SQLite) | New addition for offline support |
| Remote DB | SQL Server (direct) | SQL Server (via API) | Add API layer; SQL Server unchanged |
| Auth | BCrypt + direct DB | JWT + API | Add JWT layer; BCrypt stays on server |
| Navigation | INavigationService (stack) | GoRouter (declarative) | Complete replacement |
| Reporting | HTML generation | flutter_widget_from_html / webview | Reuse server HTML; render in-app |
| Logging | FileLogger | log + Sentry/Crashlytics | New logging strategy |
| Testing | xUnit (minimal) | flutter_test + mocktail | Build test suite from scratch |

## 15.2 Key Dart Packages

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^3.0 | State management |
| `riverpod_annotation` | ^3.0 | Riverpod code generation |
| `go_router` | ^14.0 | Declarative routing |
| `drift` | ^2.0 | SQLite ORM |
| `sqlite3_flutter_libs` | latest | SQLite native binaries |
| `dio` | ^5.0 | HTTP client |
| `freezed_annotation` | ^2.0 | Immutable model generation |
| `json_annotation` | ^4.0 | JSON serialization |
| `flutter_secure_storage` | ^9.0 | Secure JWT storage |
| `connectivity_plus` | ^6.0 | Network status detection |
| `flutter_widget_from_html` | ^0.15 | HTML report rendering |
| `intl` | ^0.19 | Arabic date/number formatting |
| `mocktail` | ^1.0 | Mocking for tests |
| `build_runner` | dev | Code generation runner |
| `drift_dev` | dev | drift code generator |
| `freezed` | dev | Freezed code generator |
| `json_serializable` | dev | JSON code generator |
| `riverpod_generator` | dev | Riverpod code generator |

## 15.3 Glossary

| Term | Arabic | Definition |
|---|---|---|
| Session | جلسة | A recorded teaching session with attendance, memorization, revision, and evaluation |
| Schedule | جدولة | A planned future session (not yet completed) |
| Memorization | حفظ | New Quran material being memorized |
| Revision | مراجعة | Previously memorized material being reviewed |
| Evaluation | تقييم | Four-domain scoring: memorization, tajweed, fluency, accuracy |
| Goal | هدف | A target (surah or juz) that a student aims to complete |
| Memorized Range | نطاق محفوظ | A tracked ayah range with status and revision cycle |
| Juz | جزء | One of 30 equal divisions of the Quran |
| Surah | سورة | A chapter of the Quran (114 total) |
| Ayah | آية | A verse of the Quran |

---

*End of Architecture Document*

> **Next Step**: Begin Phase 0 — Create the .NET Web API project with JWT authentication and student CRUD endpoints. Do not write any Flutter code until the API is stable and tested.
