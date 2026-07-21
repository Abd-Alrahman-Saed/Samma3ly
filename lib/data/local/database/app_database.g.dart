// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Teacher'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, username, passwordHash, fullName, role, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String passwordHash;
  final String fullName;
  final String role;
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.username,
      required this.passwordHash,
      required this.fullName,
      required this.role,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['full_name'] = Variable<String>(fullName);
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: Value(passwordHash),
      fullName: Value(fullName),
      role: Value(role),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      fullName: serializer.fromJson<String>(json['fullName']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'fullName': serializer.toJson<String>(fullName),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          String? passwordHash,
          String? fullName,
          String? role,
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        passwordHash: passwordHash ?? this.passwordHash,
        fullName: fullName ?? this.fullName,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, passwordHash, fullName, role, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.fullName == this.fullName &&
          other.role == this.role &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> fullName;
  final Value<String> role;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.fullName = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String passwordHash,
    required String fullName,
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : username = Value(username),
        passwordHash = Value(passwordHash),
        fullName = Value(fullName);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? fullName,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (fullName != null) 'full_name': fullName,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? passwordHash,
      Value<String>? fullName,
      Value<String>? role,
      Value<DateTime>? createdAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SurahsTable extends Surahs with TableInfo<$SurahsTable, Surah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ayahCountMeta =
      const VerificationMeta('ayahCount');
  @override
  late final GeneratedColumn<int> ayahCount = GeneratedColumn<int>(
      'ayah_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, number, name, ayahCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(Insertable<Surah> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ayah_count')) {
      context.handle(_ayahCountMeta,
          ayahCount.isAcceptableOrUnknown(data['ayah_count']!, _ayahCountMeta));
    } else if (isInserting) {
      context.missing(_ayahCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Surah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ayahCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ayah_count'])!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class Surah extends DataClass implements Insertable<Surah> {
  final int id;
  final int number;
  final String name;
  final int ayahCount;
  const Surah(
      {required this.id,
      required this.number,
      required this.name,
      required this.ayahCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['name'] = Variable<String>(name);
    map['ayah_count'] = Variable<int>(ayahCount);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      id: Value(id),
      number: Value(number),
      name: Value(name),
      ayahCount: Value(ayahCount),
    );
  }

  factory Surah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surah(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      name: serializer.fromJson<String>(json['name']),
      ayahCount: serializer.fromJson<int>(json['ayahCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'name': serializer.toJson<String>(name),
      'ayahCount': serializer.toJson<int>(ayahCount),
    };
  }

  Surah copyWith({int? id, int? number, String? name, int? ayahCount}) => Surah(
        id: id ?? this.id,
        number: number ?? this.number,
        name: name ?? this.name,
        ayahCount: ayahCount ?? this.ayahCount,
      );
  Surah copyWithCompanion(SurahsCompanion data) {
    return Surah(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      name: data.name.present ? data.name.value : this.name,
      ayahCount: data.ayahCount.present ? data.ayahCount.value : this.ayahCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Surah(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('ayahCount: $ayahCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, number, name, ayahCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.id == this.id &&
          other.number == this.number &&
          other.name == this.name &&
          other.ayahCount == this.ayahCount);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<int> id;
  final Value<int> number;
  final Value<String> name;
  final Value<int> ayahCount;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.name = const Value.absent(),
    this.ayahCount = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    required String name,
    required int ayahCount,
  })  : number = Value(number),
        name = Value(name),
        ayahCount = Value(ayahCount);
  static Insertable<Surah> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<String>? name,
    Expression<int>? ayahCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (name != null) 'name': name,
      if (ayahCount != null) 'ayah_count': ayahCount,
    });
  }

  SurahsCompanion copyWith(
      {Value<int>? id,
      Value<int>? number,
      Value<String>? name,
      Value<int>? ayahCount}) {
    return SurahsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      ayahCount: ayahCount ?? this.ayahCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ayahCount.present) {
      map['ayah_count'] = Variable<int>(ayahCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('ayahCount: $ayahCount')
          ..write(')'))
        .toString();
  }
}

class $JuzSurahRangesTable extends JuzSurahRanges
    with TableInfo<$JuzSurahRangesTable, JuzSurahRange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JuzSurahRangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _juzNumberMeta =
      const VerificationMeta('juzNumber');
  @override
  late final GeneratedColumn<int> juzNumber = GeneratedColumn<int>(
      'juz_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _surahIdMeta =
      const VerificationMeta('surahId');
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fromAyahMeta =
      const VerificationMeta('fromAyah');
  @override
  late final GeneratedColumn<int> fromAyah = GeneratedColumn<int>(
      'from_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _toAyahMeta = const VerificationMeta('toAyah');
  @override
  late final GeneratedColumn<int> toAyah = GeneratedColumn<int>(
      'to_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, juzNumber, surahId, fromAyah, toAyah];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'juz_surah_ranges';
  @override
  VerificationContext validateIntegrity(Insertable<JuzSurahRange> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('juz_number')) {
      context.handle(_juzNumberMeta,
          juzNumber.isAcceptableOrUnknown(data['juz_number']!, _juzNumberMeta));
    } else if (isInserting) {
      context.missing(_juzNumberMeta);
    }
    if (data.containsKey('surah_id')) {
      context.handle(_surahIdMeta,
          surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta));
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('from_ayah')) {
      context.handle(_fromAyahMeta,
          fromAyah.isAcceptableOrUnknown(data['from_ayah']!, _fromAyahMeta));
    } else if (isInserting) {
      context.missing(_fromAyahMeta);
    }
    if (data.containsKey('to_ayah')) {
      context.handle(_toAyahMeta,
          toAyah.isAcceptableOrUnknown(data['to_ayah']!, _toAyahMeta));
    } else if (isInserting) {
      context.missing(_toAyahMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JuzSurahRange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JuzSurahRange(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      juzNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}juz_number'])!,
      surahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_id'])!,
      fromAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_ayah'])!,
      toAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_ayah'])!,
    );
  }

  @override
  $JuzSurahRangesTable createAlias(String alias) {
    return $JuzSurahRangesTable(attachedDatabase, alias);
  }
}

class JuzSurahRange extends DataClass implements Insertable<JuzSurahRange> {
  final int id;
  final int juzNumber;
  final int surahId;
  final int fromAyah;
  final int toAyah;
  const JuzSurahRange(
      {required this.id,
      required this.juzNumber,
      required this.surahId,
      required this.fromAyah,
      required this.toAyah});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['juz_number'] = Variable<int>(juzNumber);
    map['surah_id'] = Variable<int>(surahId);
    map['from_ayah'] = Variable<int>(fromAyah);
    map['to_ayah'] = Variable<int>(toAyah);
    return map;
  }

  JuzSurahRangesCompanion toCompanion(bool nullToAbsent) {
    return JuzSurahRangesCompanion(
      id: Value(id),
      juzNumber: Value(juzNumber),
      surahId: Value(surahId),
      fromAyah: Value(fromAyah),
      toAyah: Value(toAyah),
    );
  }

  factory JuzSurahRange.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JuzSurahRange(
      id: serializer.fromJson<int>(json['id']),
      juzNumber: serializer.fromJson<int>(json['juzNumber']),
      surahId: serializer.fromJson<int>(json['surahId']),
      fromAyah: serializer.fromJson<int>(json['fromAyah']),
      toAyah: serializer.fromJson<int>(json['toAyah']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'juzNumber': serializer.toJson<int>(juzNumber),
      'surahId': serializer.toJson<int>(surahId),
      'fromAyah': serializer.toJson<int>(fromAyah),
      'toAyah': serializer.toJson<int>(toAyah),
    };
  }

  JuzSurahRange copyWith(
          {int? id,
          int? juzNumber,
          int? surahId,
          int? fromAyah,
          int? toAyah}) =>
      JuzSurahRange(
        id: id ?? this.id,
        juzNumber: juzNumber ?? this.juzNumber,
        surahId: surahId ?? this.surahId,
        fromAyah: fromAyah ?? this.fromAyah,
        toAyah: toAyah ?? this.toAyah,
      );
  JuzSurahRange copyWithCompanion(JuzSurahRangesCompanion data) {
    return JuzSurahRange(
      id: data.id.present ? data.id.value : this.id,
      juzNumber: data.juzNumber.present ? data.juzNumber.value : this.juzNumber,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      fromAyah: data.fromAyah.present ? data.fromAyah.value : this.fromAyah,
      toAyah: data.toAyah.present ? data.toAyah.value : this.toAyah,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JuzSurahRange(')
          ..write('id: $id, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('surahId: $surahId, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toAyah: $toAyah')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, juzNumber, surahId, fromAyah, toAyah);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JuzSurahRange &&
          other.id == this.id &&
          other.juzNumber == this.juzNumber &&
          other.surahId == this.surahId &&
          other.fromAyah == this.fromAyah &&
          other.toAyah == this.toAyah);
}

class JuzSurahRangesCompanion extends UpdateCompanion<JuzSurahRange> {
  final Value<int> id;
  final Value<int> juzNumber;
  final Value<int> surahId;
  final Value<int> fromAyah;
  final Value<int> toAyah;
  const JuzSurahRangesCompanion({
    this.id = const Value.absent(),
    this.juzNumber = const Value.absent(),
    this.surahId = const Value.absent(),
    this.fromAyah = const Value.absent(),
    this.toAyah = const Value.absent(),
  });
  JuzSurahRangesCompanion.insert({
    this.id = const Value.absent(),
    required int juzNumber,
    required int surahId,
    required int fromAyah,
    required int toAyah,
  })  : juzNumber = Value(juzNumber),
        surahId = Value(surahId),
        fromAyah = Value(fromAyah),
        toAyah = Value(toAyah);
  static Insertable<JuzSurahRange> custom({
    Expression<int>? id,
    Expression<int>? juzNumber,
    Expression<int>? surahId,
    Expression<int>? fromAyah,
    Expression<int>? toAyah,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (juzNumber != null) 'juz_number': juzNumber,
      if (surahId != null) 'surah_id': surahId,
      if (fromAyah != null) 'from_ayah': fromAyah,
      if (toAyah != null) 'to_ayah': toAyah,
    });
  }

  JuzSurahRangesCompanion copyWith(
      {Value<int>? id,
      Value<int>? juzNumber,
      Value<int>? surahId,
      Value<int>? fromAyah,
      Value<int>? toAyah}) {
    return JuzSurahRangesCompanion(
      id: id ?? this.id,
      juzNumber: juzNumber ?? this.juzNumber,
      surahId: surahId ?? this.surahId,
      fromAyah: fromAyah ?? this.fromAyah,
      toAyah: toAyah ?? this.toAyah,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (juzNumber.present) {
      map['juz_number'] = Variable<int>(juzNumber.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (fromAyah.present) {
      map['from_ayah'] = Variable<int>(fromAyah.value);
    }
    if (toAyah.present) {
      map['to_ayah'] = Variable<int>(toAyah.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JuzSurahRangesCompanion(')
          ..write('id: $id, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('surahId: $surahId, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toAyah: $toAyah')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentNameMeta =
      const VerificationMeta('parentName');
  @override
  late final GeneratedColumn<String> parentName = GeneratedColumn<String>(
      'parent_name', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _parentPhoneMeta =
      const VerificationMeta('parentPhone');
  @override
  late final GeneratedColumn<String> parentPhone = GeneratedColumn<String>(
      'parent_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentSurahIdMeta =
      const VerificationMeta('currentSurahId');
  @override
  late final GeneratedColumn<int> currentSurahId = GeneratedColumn<int>(
      'current_surah_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastCompletedSurahIdMeta =
      const VerificationMeta('lastCompletedSurahId');
  @override
  late final GeneratedColumn<int> lastCompletedSurahId = GeneratedColumn<int>(
      'last_completed_surah_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalCompletedJuzMeta =
      const VerificationMeta('totalCompletedJuz');
  @override
  late final GeneratedColumn<int> totalCompletedJuz = GeneratedColumn<int>(
      'total_completed_juz', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('مبتدئ'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fullName,
        age,
        phone,
        address,
        parentName,
        parentPhone,
        currentSurahId,
        lastCompletedSurahId,
        totalCompletedJuz,
        level,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(Insertable<Student> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('parent_name')) {
      context.handle(
          _parentNameMeta,
          parentName.isAcceptableOrUnknown(
              data['parent_name']!, _parentNameMeta));
    }
    if (data.containsKey('parent_phone')) {
      context.handle(
          _parentPhoneMeta,
          parentPhone.isAcceptableOrUnknown(
              data['parent_phone']!, _parentPhoneMeta));
    }
    if (data.containsKey('current_surah_id')) {
      context.handle(
          _currentSurahIdMeta,
          currentSurahId.isAcceptableOrUnknown(
              data['current_surah_id']!, _currentSurahIdMeta));
    }
    if (data.containsKey('last_completed_surah_id')) {
      context.handle(
          _lastCompletedSurahIdMeta,
          lastCompletedSurahId.isAcceptableOrUnknown(
              data['last_completed_surah_id']!, _lastCompletedSurahIdMeta));
    }
    if (data.containsKey('total_completed_juz')) {
      context.handle(
          _totalCompletedJuzMeta,
          totalCompletedJuz.isAcceptableOrUnknown(
              data['total_completed_juz']!, _totalCompletedJuzMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      parentName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_name']),
      parentPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_phone']),
      currentSurahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_surah_id']),
      lastCompletedSurahId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_completed_surah_id']),
      totalCompletedJuz: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_completed_juz'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final int id;
  final String fullName;
  final int age;
  final String phone;
  final String address;
  final String? parentName;
  final String? parentPhone;
  final int? currentSurahId;
  final int? lastCompletedSurahId;
  final int totalCompletedJuz;
  final String level;
  final DateTime createdAt;
  const Student(
      {required this.id,
      required this.fullName,
      required this.age,
      required this.phone,
      required this.address,
      this.parentName,
      this.parentPhone,
      this.currentSurahId,
      this.lastCompletedSurahId,
      required this.totalCompletedJuz,
      required this.level,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['full_name'] = Variable<String>(fullName);
    map['age'] = Variable<int>(age);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || parentName != null) {
      map['parent_name'] = Variable<String>(parentName);
    }
    if (!nullToAbsent || parentPhone != null) {
      map['parent_phone'] = Variable<String>(parentPhone);
    }
    if (!nullToAbsent || currentSurahId != null) {
      map['current_surah_id'] = Variable<int>(currentSurahId);
    }
    if (!nullToAbsent || lastCompletedSurahId != null) {
      map['last_completed_surah_id'] = Variable<int>(lastCompletedSurahId);
    }
    map['total_completed_juz'] = Variable<int>(totalCompletedJuz);
    map['level'] = Variable<String>(level);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      fullName: Value(fullName),
      age: Value(age),
      phone: Value(phone),
      address: Value(address),
      parentName: parentName == null && nullToAbsent
          ? const Value.absent()
          : Value(parentName),
      parentPhone: parentPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(parentPhone),
      currentSurahId: currentSurahId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentSurahId),
      lastCompletedSurahId: lastCompletedSurahId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedSurahId),
      totalCompletedJuz: Value(totalCompletedJuz),
      level: Value(level),
      createdAt: Value(createdAt),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<int>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      age: serializer.fromJson<int>(json['age']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      parentName: serializer.fromJson<String?>(json['parentName']),
      parentPhone: serializer.fromJson<String?>(json['parentPhone']),
      currentSurahId: serializer.fromJson<int?>(json['currentSurahId']),
      lastCompletedSurahId:
          serializer.fromJson<int?>(json['lastCompletedSurahId']),
      totalCompletedJuz: serializer.fromJson<int>(json['totalCompletedJuz']),
      level: serializer.fromJson<String>(json['level']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fullName': serializer.toJson<String>(fullName),
      'age': serializer.toJson<int>(age),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'parentName': serializer.toJson<String?>(parentName),
      'parentPhone': serializer.toJson<String?>(parentPhone),
      'currentSurahId': serializer.toJson<int?>(currentSurahId),
      'lastCompletedSurahId': serializer.toJson<int?>(lastCompletedSurahId),
      'totalCompletedJuz': serializer.toJson<int>(totalCompletedJuz),
      'level': serializer.toJson<String>(level),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Student copyWith(
          {int? id,
          String? fullName,
          int? age,
          String? phone,
          String? address,
          Value<String?> parentName = const Value.absent(),
          Value<String?> parentPhone = const Value.absent(),
          Value<int?> currentSurahId = const Value.absent(),
          Value<int?> lastCompletedSurahId = const Value.absent(),
          int? totalCompletedJuz,
          String? level,
          DateTime? createdAt}) =>
      Student(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        age: age ?? this.age,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        parentName: parentName.present ? parentName.value : this.parentName,
        parentPhone: parentPhone.present ? parentPhone.value : this.parentPhone,
        currentSurahId:
            currentSurahId.present ? currentSurahId.value : this.currentSurahId,
        lastCompletedSurahId: lastCompletedSurahId.present
            ? lastCompletedSurahId.value
            : this.lastCompletedSurahId,
        totalCompletedJuz: totalCompletedJuz ?? this.totalCompletedJuz,
        level: level ?? this.level,
        createdAt: createdAt ?? this.createdAt,
      );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      age: data.age.present ? data.age.value : this.age,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      parentName:
          data.parentName.present ? data.parentName.value : this.parentName,
      parentPhone:
          data.parentPhone.present ? data.parentPhone.value : this.parentPhone,
      currentSurahId: data.currentSurahId.present
          ? data.currentSurahId.value
          : this.currentSurahId,
      lastCompletedSurahId: data.lastCompletedSurahId.present
          ? data.lastCompletedSurahId.value
          : this.lastCompletedSurahId,
      totalCompletedJuz: data.totalCompletedJuz.present
          ? data.totalCompletedJuz.value
          : this.totalCompletedJuz,
      level: data.level.present ? data.level.value : this.level,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('age: $age, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('parentName: $parentName, ')
          ..write('parentPhone: $parentPhone, ')
          ..write('currentSurahId: $currentSurahId, ')
          ..write('lastCompletedSurahId: $lastCompletedSurahId, ')
          ..write('totalCompletedJuz: $totalCompletedJuz, ')
          ..write('level: $level, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      fullName,
      age,
      phone,
      address,
      parentName,
      parentPhone,
      currentSurahId,
      lastCompletedSurahId,
      totalCompletedJuz,
      level,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.age == this.age &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.parentName == this.parentName &&
          other.parentPhone == this.parentPhone &&
          other.currentSurahId == this.currentSurahId &&
          other.lastCompletedSurahId == this.lastCompletedSurahId &&
          other.totalCompletedJuz == this.totalCompletedJuz &&
          other.level == this.level &&
          other.createdAt == this.createdAt);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<int> id;
  final Value<String> fullName;
  final Value<int> age;
  final Value<String> phone;
  final Value<String> address;
  final Value<String?> parentName;
  final Value<String?> parentPhone;
  final Value<int?> currentSurahId;
  final Value<int?> lastCompletedSurahId;
  final Value<int> totalCompletedJuz;
  final Value<String> level;
  final Value<DateTime> createdAt;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.age = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.parentName = const Value.absent(),
    this.parentPhone = const Value.absent(),
    this.currentSurahId = const Value.absent(),
    this.lastCompletedSurahId = const Value.absent(),
    this.totalCompletedJuz = const Value.absent(),
    this.level = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StudentsCompanion.insert({
    this.id = const Value.absent(),
    required String fullName,
    required int age,
    required String phone,
    required String address,
    this.parentName = const Value.absent(),
    this.parentPhone = const Value.absent(),
    this.currentSurahId = const Value.absent(),
    this.lastCompletedSurahId = const Value.absent(),
    this.totalCompletedJuz = const Value.absent(),
    this.level = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : fullName = Value(fullName),
        age = Value(age),
        phone = Value(phone),
        address = Value(address);
  static Insertable<Student> custom({
    Expression<int>? id,
    Expression<String>? fullName,
    Expression<int>? age,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? parentName,
    Expression<String>? parentPhone,
    Expression<int>? currentSurahId,
    Expression<int>? lastCompletedSurahId,
    Expression<int>? totalCompletedJuz,
    Expression<String>? level,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (age != null) 'age': age,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (parentName != null) 'parent_name': parentName,
      if (parentPhone != null) 'parent_phone': parentPhone,
      if (currentSurahId != null) 'current_surah_id': currentSurahId,
      if (lastCompletedSurahId != null)
        'last_completed_surah_id': lastCompletedSurahId,
      if (totalCompletedJuz != null) 'total_completed_juz': totalCompletedJuz,
      if (level != null) 'level': level,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StudentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? fullName,
      Value<int>? age,
      Value<String>? phone,
      Value<String>? address,
      Value<String?>? parentName,
      Value<String?>? parentPhone,
      Value<int?>? currentSurahId,
      Value<int?>? lastCompletedSurahId,
      Value<int>? totalCompletedJuz,
      Value<String>? level,
      Value<DateTime>? createdAt}) {
    return StudentsCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      currentSurahId: currentSurahId ?? this.currentSurahId,
      lastCompletedSurahId: lastCompletedSurahId ?? this.lastCompletedSurahId,
      totalCompletedJuz: totalCompletedJuz ?? this.totalCompletedJuz,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (parentName.present) {
      map['parent_name'] = Variable<String>(parentName.value);
    }
    if (parentPhone.present) {
      map['parent_phone'] = Variable<String>(parentPhone.value);
    }
    if (currentSurahId.present) {
      map['current_surah_id'] = Variable<int>(currentSurahId.value);
    }
    if (lastCompletedSurahId.present) {
      map['last_completed_surah_id'] =
          Variable<int>(lastCompletedSurahId.value);
    }
    if (totalCompletedJuz.present) {
      map['total_completed_juz'] = Variable<int>(totalCompletedJuz.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('age: $age, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('parentName: $parentName, ')
          ..write('parentPhone: $parentPhone, ')
          ..write('currentSurahId: $currentSurahId, ')
          ..write('lastCompletedSurahId: $lastCompletedSurahId, ')
          ..write('totalCompletedJuz: $totalCompletedJuz, ')
          ..write('level: $level, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attendanceStatusMeta =
      const VerificationMeta('attendanceStatus');
  @override
  late final GeneratedColumn<String> attendanceStatus = GeneratedColumn<String>(
      'attendance_status', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('حاضر'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, studentId, date, time, attendanceStatus, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('attendance_status')) {
      context.handle(
          _attendanceStatusMeta,
          attendanceStatus.isAcceptableOrUnknown(
              data['attendance_status']!, _attendanceStatusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
      attendanceStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}attendance_status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int studentId;
  final DateTime date;
  final String time;
  final String attendanceStatus;
  final String? notes;
  final DateTime createdAt;
  const Session(
      {required this.id,
      required this.studentId,
      required this.date,
      required this.time,
      required this.attendanceStatus,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['date'] = Variable<DateTime>(date);
    map['time'] = Variable<String>(time);
    map['attendance_status'] = Variable<String>(attendanceStatus);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      date: Value(date),
      time: Value(time),
      attendanceStatus: Value(attendanceStatus),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      date: serializer.fromJson<DateTime>(json['date']),
      time: serializer.fromJson<String>(json['time']),
      attendanceStatus: serializer.fromJson<String>(json['attendanceStatus']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'date': serializer.toJson<DateTime>(date),
      'time': serializer.toJson<String>(time),
      'attendanceStatus': serializer.toJson<String>(attendanceStatus),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Session copyWith(
          {int? id,
          int? studentId,
          DateTime? date,
          String? time,
          String? attendanceStatus,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      Session(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        date: date ?? this.date,
        time: time ?? this.time,
        attendanceStatus: attendanceStatus ?? this.attendanceStatus,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      attendanceStatus: data.attendanceStatus.present
          ? data.attendanceStatus.value
          : this.attendanceStatus,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('attendanceStatus: $attendanceStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, studentId, date, time, attendanceStatus, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.date == this.date &&
          other.time == this.time &&
          other.attendanceStatus == this.attendanceStatus &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<DateTime> date;
  final Value<String> time;
  final Value<String> attendanceStatus;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.attendanceStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required DateTime date,
    required String time,
    this.attendanceStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : studentId = Value(studentId),
        date = Value(date),
        time = Value(time);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<DateTime>? date,
    Expression<String>? time,
    Expression<String>? attendanceStatus,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (attendanceStatus != null) 'attendance_status': attendanceStatus,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? studentId,
      Value<DateTime>? date,
      Value<String>? time,
      Value<String>? attendanceStatus,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return SessionsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      time: time ?? this.time,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (attendanceStatus.present) {
      map['attendance_status'] = Variable<String>(attendanceStatus.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('attendanceStatus: $attendanceStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SessionMemorizationsTable extends SessionMemorizations
    with TableInfo<$SessionMemorizationsTable, SessionMemorization> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionMemorizationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _surahIdMeta =
      const VerificationMeta('surahId');
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fromAyahMeta =
      const VerificationMeta('fromAyah');
  @override
  late final GeneratedColumn<int> fromAyah = GeneratedColumn<int>(
      'from_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _toAyahMeta = const VerificationMeta('toAyah');
  @override
  late final GeneratedColumn<int> toAyah = GeneratedColumn<int>(
      'to_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, surahId, fromAyah, toAyah];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_memorizations';
  @override
  VerificationContext validateIntegrity(
      Insertable<SessionMemorization> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('surah_id')) {
      context.handle(_surahIdMeta,
          surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta));
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('from_ayah')) {
      context.handle(_fromAyahMeta,
          fromAyah.isAcceptableOrUnknown(data['from_ayah']!, _fromAyahMeta));
    } else if (isInserting) {
      context.missing(_fromAyahMeta);
    }
    if (data.containsKey('to_ayah')) {
      context.handle(_toAyahMeta,
          toAyah.isAcceptableOrUnknown(data['to_ayah']!, _toAyahMeta));
    } else if (isInserting) {
      context.missing(_toAyahMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionMemorization map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionMemorization(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      surahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_id'])!,
      fromAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_ayah'])!,
      toAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_ayah'])!,
    );
  }

  @override
  $SessionMemorizationsTable createAlias(String alias) {
    return $SessionMemorizationsTable(attachedDatabase, alias);
  }
}

class SessionMemorization extends DataClass
    implements Insertable<SessionMemorization> {
  final int id;
  final int sessionId;
  final int surahId;
  final int fromAyah;
  final int toAyah;
  const SessionMemorization(
      {required this.id,
      required this.sessionId,
      required this.surahId,
      required this.fromAyah,
      required this.toAyah});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['surah_id'] = Variable<int>(surahId);
    map['from_ayah'] = Variable<int>(fromAyah);
    map['to_ayah'] = Variable<int>(toAyah);
    return map;
  }

  SessionMemorizationsCompanion toCompanion(bool nullToAbsent) {
    return SessionMemorizationsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      surahId: Value(surahId),
      fromAyah: Value(fromAyah),
      toAyah: Value(toAyah),
    );
  }

  factory SessionMemorization.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionMemorization(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      surahId: serializer.fromJson<int>(json['surahId']),
      fromAyah: serializer.fromJson<int>(json['fromAyah']),
      toAyah: serializer.fromJson<int>(json['toAyah']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'surahId': serializer.toJson<int>(surahId),
      'fromAyah': serializer.toJson<int>(fromAyah),
      'toAyah': serializer.toJson<int>(toAyah),
    };
  }

  SessionMemorization copyWith(
          {int? id,
          int? sessionId,
          int? surahId,
          int? fromAyah,
          int? toAyah}) =>
      SessionMemorization(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        surahId: surahId ?? this.surahId,
        fromAyah: fromAyah ?? this.fromAyah,
        toAyah: toAyah ?? this.toAyah,
      );
  SessionMemorization copyWithCompanion(SessionMemorizationsCompanion data) {
    return SessionMemorization(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      fromAyah: data.fromAyah.present ? data.fromAyah.value : this.fromAyah,
      toAyah: data.toAyah.present ? data.toAyah.value : this.toAyah,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionMemorization(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('surahId: $surahId, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toAyah: $toAyah')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, surahId, fromAyah, toAyah);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionMemorization &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.surahId == this.surahId &&
          other.fromAyah == this.fromAyah &&
          other.toAyah == this.toAyah);
}

class SessionMemorizationsCompanion
    extends UpdateCompanion<SessionMemorization> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> surahId;
  final Value<int> fromAyah;
  final Value<int> toAyah;
  const SessionMemorizationsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.surahId = const Value.absent(),
    this.fromAyah = const Value.absent(),
    this.toAyah = const Value.absent(),
  });
  SessionMemorizationsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int surahId,
    required int fromAyah,
    required int toAyah,
  })  : sessionId = Value(sessionId),
        surahId = Value(surahId),
        fromAyah = Value(fromAyah),
        toAyah = Value(toAyah);
  static Insertable<SessionMemorization> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? surahId,
    Expression<int>? fromAyah,
    Expression<int>? toAyah,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (surahId != null) 'surah_id': surahId,
      if (fromAyah != null) 'from_ayah': fromAyah,
      if (toAyah != null) 'to_ayah': toAyah,
    });
  }

  SessionMemorizationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? surahId,
      Value<int>? fromAyah,
      Value<int>? toAyah}) {
    return SessionMemorizationsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      surahId: surahId ?? this.surahId,
      fromAyah: fromAyah ?? this.fromAyah,
      toAyah: toAyah ?? this.toAyah,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (fromAyah.present) {
      map['from_ayah'] = Variable<int>(fromAyah.value);
    }
    if (toAyah.present) {
      map['to_ayah'] = Variable<int>(toAyah.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionMemorizationsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('surahId: $surahId, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toAyah: $toAyah')
          ..write(')'))
        .toString();
  }
}

class $SessionRevisionsTable extends SessionRevisions
    with TableInfo<$SessionRevisionsTable, SessionRevision> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionRevisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _surahIdMeta =
      const VerificationMeta('surahId');
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fromAyahMeta =
      const VerificationMeta('fromAyah');
  @override
  late final GeneratedColumn<int> fromAyah = GeneratedColumn<int>(
      'from_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _toAyahMeta = const VerificationMeta('toAyah');
  @override
  late final GeneratedColumn<int> toAyah = GeneratedColumn<int>(
      'to_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, surahId, fromAyah, toAyah];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_revisions';
  @override
  VerificationContext validateIntegrity(Insertable<SessionRevision> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('surah_id')) {
      context.handle(_surahIdMeta,
          surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta));
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('from_ayah')) {
      context.handle(_fromAyahMeta,
          fromAyah.isAcceptableOrUnknown(data['from_ayah']!, _fromAyahMeta));
    } else if (isInserting) {
      context.missing(_fromAyahMeta);
    }
    if (data.containsKey('to_ayah')) {
      context.handle(_toAyahMeta,
          toAyah.isAcceptableOrUnknown(data['to_ayah']!, _toAyahMeta));
    } else if (isInserting) {
      context.missing(_toAyahMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRevision map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRevision(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      surahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_id'])!,
      fromAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_ayah'])!,
      toAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_ayah'])!,
    );
  }

  @override
  $SessionRevisionsTable createAlias(String alias) {
    return $SessionRevisionsTable(attachedDatabase, alias);
  }
}

class SessionRevision extends DataClass implements Insertable<SessionRevision> {
  final int id;
  final int sessionId;
  final int surahId;
  final int fromAyah;
  final int toAyah;
  const SessionRevision(
      {required this.id,
      required this.sessionId,
      required this.surahId,
      required this.fromAyah,
      required this.toAyah});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['surah_id'] = Variable<int>(surahId);
    map['from_ayah'] = Variable<int>(fromAyah);
    map['to_ayah'] = Variable<int>(toAyah);
    return map;
  }

  SessionRevisionsCompanion toCompanion(bool nullToAbsent) {
    return SessionRevisionsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      surahId: Value(surahId),
      fromAyah: Value(fromAyah),
      toAyah: Value(toAyah),
    );
  }

  factory SessionRevision.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRevision(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      surahId: serializer.fromJson<int>(json['surahId']),
      fromAyah: serializer.fromJson<int>(json['fromAyah']),
      toAyah: serializer.fromJson<int>(json['toAyah']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'surahId': serializer.toJson<int>(surahId),
      'fromAyah': serializer.toJson<int>(fromAyah),
      'toAyah': serializer.toJson<int>(toAyah),
    };
  }

  SessionRevision copyWith(
          {int? id,
          int? sessionId,
          int? surahId,
          int? fromAyah,
          int? toAyah}) =>
      SessionRevision(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        surahId: surahId ?? this.surahId,
        fromAyah: fromAyah ?? this.fromAyah,
        toAyah: toAyah ?? this.toAyah,
      );
  SessionRevision copyWithCompanion(SessionRevisionsCompanion data) {
    return SessionRevision(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      fromAyah: data.fromAyah.present ? data.fromAyah.value : this.fromAyah,
      toAyah: data.toAyah.present ? data.toAyah.value : this.toAyah,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRevision(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('surahId: $surahId, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toAyah: $toAyah')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, surahId, fromAyah, toAyah);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRevision &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.surahId == this.surahId &&
          other.fromAyah == this.fromAyah &&
          other.toAyah == this.toAyah);
}

class SessionRevisionsCompanion extends UpdateCompanion<SessionRevision> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> surahId;
  final Value<int> fromAyah;
  final Value<int> toAyah;
  const SessionRevisionsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.surahId = const Value.absent(),
    this.fromAyah = const Value.absent(),
    this.toAyah = const Value.absent(),
  });
  SessionRevisionsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int surahId,
    required int fromAyah,
    required int toAyah,
  })  : sessionId = Value(sessionId),
        surahId = Value(surahId),
        fromAyah = Value(fromAyah),
        toAyah = Value(toAyah);
  static Insertable<SessionRevision> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? surahId,
    Expression<int>? fromAyah,
    Expression<int>? toAyah,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (surahId != null) 'surah_id': surahId,
      if (fromAyah != null) 'from_ayah': fromAyah,
      if (toAyah != null) 'to_ayah': toAyah,
    });
  }

  SessionRevisionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? surahId,
      Value<int>? fromAyah,
      Value<int>? toAyah}) {
    return SessionRevisionsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      surahId: surahId ?? this.surahId,
      fromAyah: fromAyah ?? this.fromAyah,
      toAyah: toAyah ?? this.toAyah,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (fromAyah.present) {
      map['from_ayah'] = Variable<int>(fromAyah.value);
    }
    if (toAyah.present) {
      map['to_ayah'] = Variable<int>(toAyah.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionRevisionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('surahId: $surahId, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toAyah: $toAyah')
          ..write(')'))
        .toString();
  }
}

class $SessionEvaluationsTable extends SessionEvaluations
    with TableInfo<$SessionEvaluationsTable, SessionEvaluation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionEvaluationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _memorizationScoreMeta =
      const VerificationMeta('memorizationScore');
  @override
  late final GeneratedColumn<double> memorizationScore =
      GeneratedColumn<double>('memorization_score', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _tajweedScoreMeta =
      const VerificationMeta('tajweedScore');
  @override
  late final GeneratedColumn<double> tajweedScore = GeneratedColumn<double>(
      'tajweed_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _fluencyScoreMeta =
      const VerificationMeta('fluencyScore');
  @override
  late final GeneratedColumn<double> fluencyScore = GeneratedColumn<double>(
      'fluency_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _accuracyScoreMeta =
      const VerificationMeta('accuracyScore');
  @override
  late final GeneratedColumn<double> accuracyScore = GeneratedColumn<double>(
      'accuracy_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        memorizationScore,
        tajweedScore,
        fluencyScore,
        accuracyScore
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_evaluations';
  @override
  VerificationContext validateIntegrity(Insertable<SessionEvaluation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('memorization_score')) {
      context.handle(
          _memorizationScoreMeta,
          memorizationScore.isAcceptableOrUnknown(
              data['memorization_score']!, _memorizationScoreMeta));
    }
    if (data.containsKey('tajweed_score')) {
      context.handle(
          _tajweedScoreMeta,
          tajweedScore.isAcceptableOrUnknown(
              data['tajweed_score']!, _tajweedScoreMeta));
    }
    if (data.containsKey('fluency_score')) {
      context.handle(
          _fluencyScoreMeta,
          fluencyScore.isAcceptableOrUnknown(
              data['fluency_score']!, _fluencyScoreMeta));
    }
    if (data.containsKey('accuracy_score')) {
      context.handle(
          _accuracyScoreMeta,
          accuracyScore.isAcceptableOrUnknown(
              data['accuracy_score']!, _accuracyScoreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionEvaluation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionEvaluation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      memorizationScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}memorization_score'])!,
      tajweedScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tajweed_score'])!,
      fluencyScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fluency_score'])!,
      accuracyScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy_score'])!,
    );
  }

  @override
  $SessionEvaluationsTable createAlias(String alias) {
    return $SessionEvaluationsTable(attachedDatabase, alias);
  }
}

class SessionEvaluation extends DataClass
    implements Insertable<SessionEvaluation> {
  final int id;
  final int sessionId;
  final double memorizationScore;
  final double tajweedScore;
  final double fluencyScore;
  final double accuracyScore;
  const SessionEvaluation(
      {required this.id,
      required this.sessionId,
      required this.memorizationScore,
      required this.tajweedScore,
      required this.fluencyScore,
      required this.accuracyScore});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['memorization_score'] = Variable<double>(memorizationScore);
    map['tajweed_score'] = Variable<double>(tajweedScore);
    map['fluency_score'] = Variable<double>(fluencyScore);
    map['accuracy_score'] = Variable<double>(accuracyScore);
    return map;
  }

  SessionEvaluationsCompanion toCompanion(bool nullToAbsent) {
    return SessionEvaluationsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      memorizationScore: Value(memorizationScore),
      tajweedScore: Value(tajweedScore),
      fluencyScore: Value(fluencyScore),
      accuracyScore: Value(accuracyScore),
    );
  }

  factory SessionEvaluation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionEvaluation(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      memorizationScore: serializer.fromJson<double>(json['memorizationScore']),
      tajweedScore: serializer.fromJson<double>(json['tajweedScore']),
      fluencyScore: serializer.fromJson<double>(json['fluencyScore']),
      accuracyScore: serializer.fromJson<double>(json['accuracyScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'memorizationScore': serializer.toJson<double>(memorizationScore),
      'tajweedScore': serializer.toJson<double>(tajweedScore),
      'fluencyScore': serializer.toJson<double>(fluencyScore),
      'accuracyScore': serializer.toJson<double>(accuracyScore),
    };
  }

  SessionEvaluation copyWith(
          {int? id,
          int? sessionId,
          double? memorizationScore,
          double? tajweedScore,
          double? fluencyScore,
          double? accuracyScore}) =>
      SessionEvaluation(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        memorizationScore: memorizationScore ?? this.memorizationScore,
        tajweedScore: tajweedScore ?? this.tajweedScore,
        fluencyScore: fluencyScore ?? this.fluencyScore,
        accuracyScore: accuracyScore ?? this.accuracyScore,
      );
  SessionEvaluation copyWithCompanion(SessionEvaluationsCompanion data) {
    return SessionEvaluation(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      memorizationScore: data.memorizationScore.present
          ? data.memorizationScore.value
          : this.memorizationScore,
      tajweedScore: data.tajweedScore.present
          ? data.tajweedScore.value
          : this.tajweedScore,
      fluencyScore: data.fluencyScore.present
          ? data.fluencyScore.value
          : this.fluencyScore,
      accuracyScore: data.accuracyScore.present
          ? data.accuracyScore.value
          : this.accuracyScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionEvaluation(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('memorizationScore: $memorizationScore, ')
          ..write('tajweedScore: $tajweedScore, ')
          ..write('fluencyScore: $fluencyScore, ')
          ..write('accuracyScore: $accuracyScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, memorizationScore,
      tajweedScore, fluencyScore, accuracyScore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionEvaluation &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.memorizationScore == this.memorizationScore &&
          other.tajweedScore == this.tajweedScore &&
          other.fluencyScore == this.fluencyScore &&
          other.accuracyScore == this.accuracyScore);
}

class SessionEvaluationsCompanion extends UpdateCompanion<SessionEvaluation> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<double> memorizationScore;
  final Value<double> tajweedScore;
  final Value<double> fluencyScore;
  final Value<double> accuracyScore;
  const SessionEvaluationsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.memorizationScore = const Value.absent(),
    this.tajweedScore = const Value.absent(),
    this.fluencyScore = const Value.absent(),
    this.accuracyScore = const Value.absent(),
  });
  SessionEvaluationsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    this.memorizationScore = const Value.absent(),
    this.tajweedScore = const Value.absent(),
    this.fluencyScore = const Value.absent(),
    this.accuracyScore = const Value.absent(),
  }) : sessionId = Value(sessionId);
  static Insertable<SessionEvaluation> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<double>? memorizationScore,
    Expression<double>? tajweedScore,
    Expression<double>? fluencyScore,
    Expression<double>? accuracyScore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (memorizationScore != null) 'memorization_score': memorizationScore,
      if (tajweedScore != null) 'tajweed_score': tajweedScore,
      if (fluencyScore != null) 'fluency_score': fluencyScore,
      if (accuracyScore != null) 'accuracy_score': accuracyScore,
    });
  }

  SessionEvaluationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<double>? memorizationScore,
      Value<double>? tajweedScore,
      Value<double>? fluencyScore,
      Value<double>? accuracyScore}) {
    return SessionEvaluationsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      memorizationScore: memorizationScore ?? this.memorizationScore,
      tajweedScore: tajweedScore ?? this.tajweedScore,
      fluencyScore: fluencyScore ?? this.fluencyScore,
      accuracyScore: accuracyScore ?? this.accuracyScore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (memorizationScore.present) {
      map['memorization_score'] = Variable<double>(memorizationScore.value);
    }
    if (tajweedScore.present) {
      map['tajweed_score'] = Variable<double>(tajweedScore.value);
    }
    if (fluencyScore.present) {
      map['fluency_score'] = Variable<double>(fluencyScore.value);
    }
    if (accuracyScore.present) {
      map['accuracy_score'] = Variable<double>(accuracyScore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionEvaluationsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('memorizationScore: $memorizationScore, ')
          ..write('tajweedScore: $tajweedScore, ')
          ..write('fluencyScore: $fluencyScore, ')
          ..write('accuracyScore: $accuracyScore')
          ..write(')'))
        .toString();
  }
}

class $SchedulesTable extends Schedules
    with TableInfo<$SchedulesTable, Schedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memorizationSurahIdMeta =
      const VerificationMeta('memorizationSurahId');
  @override
  late final GeneratedColumn<int> memorizationSurahId = GeneratedColumn<int>(
      'memorization_surah_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _memorizationFromAyahMeta =
      const VerificationMeta('memorizationFromAyah');
  @override
  late final GeneratedColumn<int> memorizationFromAyah = GeneratedColumn<int>(
      'memorization_from_ayah', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _memorizationToAyahMeta =
      const VerificationMeta('memorizationToAyah');
  @override
  late final GeneratedColumn<int> memorizationToAyah = GeneratedColumn<int>(
      'memorization_to_ayah', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _revisionSurahIdMeta =
      const VerificationMeta('revisionSurahId');
  @override
  late final GeneratedColumn<int> revisionSurahId = GeneratedColumn<int>(
      'revision_surah_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _revisionFromAyahMeta =
      const VerificationMeta('revisionFromAyah');
  @override
  late final GeneratedColumn<int> revisionFromAyah = GeneratedColumn<int>(
      'revision_from_ayah', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _revisionToAyahMeta =
      const VerificationMeta('revisionToAyah');
  @override
  late final GeneratedColumn<int> revisionToAyah = GeneratedColumn<int>(
      'revision_to_ayah', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        date,
        time,
        memorizationSurahId,
        memorizationFromAyah,
        memorizationToAyah,
        revisionSurahId,
        revisionFromAyah,
        revisionToAyah,
        isCompleted,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedules';
  @override
  VerificationContext validateIntegrity(Insertable<Schedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('memorization_surah_id')) {
      context.handle(
          _memorizationSurahIdMeta,
          memorizationSurahId.isAcceptableOrUnknown(
              data['memorization_surah_id']!, _memorizationSurahIdMeta));
    }
    if (data.containsKey('memorization_from_ayah')) {
      context.handle(
          _memorizationFromAyahMeta,
          memorizationFromAyah.isAcceptableOrUnknown(
              data['memorization_from_ayah']!, _memorizationFromAyahMeta));
    }
    if (data.containsKey('memorization_to_ayah')) {
      context.handle(
          _memorizationToAyahMeta,
          memorizationToAyah.isAcceptableOrUnknown(
              data['memorization_to_ayah']!, _memorizationToAyahMeta));
    }
    if (data.containsKey('revision_surah_id')) {
      context.handle(
          _revisionSurahIdMeta,
          revisionSurahId.isAcceptableOrUnknown(
              data['revision_surah_id']!, _revisionSurahIdMeta));
    }
    if (data.containsKey('revision_from_ayah')) {
      context.handle(
          _revisionFromAyahMeta,
          revisionFromAyah.isAcceptableOrUnknown(
              data['revision_from_ayah']!, _revisionFromAyahMeta));
    }
    if (data.containsKey('revision_to_ayah')) {
      context.handle(
          _revisionToAyahMeta,
          revisionToAyah.isAcceptableOrUnknown(
              data['revision_to_ayah']!, _revisionToAyahMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Schedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Schedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
      memorizationSurahId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}memorization_surah_id']),
      memorizationFromAyah: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}memorization_from_ayah']),
      memorizationToAyah: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}memorization_to_ayah']),
      revisionSurahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}revision_surah_id']),
      revisionFromAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}revision_from_ayah']),
      revisionToAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}revision_to_ayah']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SchedulesTable createAlias(String alias) {
    return $SchedulesTable(attachedDatabase, alias);
  }
}

class Schedule extends DataClass implements Insertable<Schedule> {
  final int id;
  final int studentId;
  final DateTime date;
  final String time;
  final int? memorizationSurahId;
  final int? memorizationFromAyah;
  final int? memorizationToAyah;
  final int? revisionSurahId;
  final int? revisionFromAyah;
  final int? revisionToAyah;
  final bool isCompleted;
  final DateTime createdAt;
  const Schedule(
      {required this.id,
      required this.studentId,
      required this.date,
      required this.time,
      this.memorizationSurahId,
      this.memorizationFromAyah,
      this.memorizationToAyah,
      this.revisionSurahId,
      this.revisionFromAyah,
      this.revisionToAyah,
      required this.isCompleted,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['date'] = Variable<DateTime>(date);
    map['time'] = Variable<String>(time);
    if (!nullToAbsent || memorizationSurahId != null) {
      map['memorization_surah_id'] = Variable<int>(memorizationSurahId);
    }
    if (!nullToAbsent || memorizationFromAyah != null) {
      map['memorization_from_ayah'] = Variable<int>(memorizationFromAyah);
    }
    if (!nullToAbsent || memorizationToAyah != null) {
      map['memorization_to_ayah'] = Variable<int>(memorizationToAyah);
    }
    if (!nullToAbsent || revisionSurahId != null) {
      map['revision_surah_id'] = Variable<int>(revisionSurahId);
    }
    if (!nullToAbsent || revisionFromAyah != null) {
      map['revision_from_ayah'] = Variable<int>(revisionFromAyah);
    }
    if (!nullToAbsent || revisionToAyah != null) {
      map['revision_to_ayah'] = Variable<int>(revisionToAyah);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      id: Value(id),
      studentId: Value(studentId),
      date: Value(date),
      time: Value(time),
      memorizationSurahId: memorizationSurahId == null && nullToAbsent
          ? const Value.absent()
          : Value(memorizationSurahId),
      memorizationFromAyah: memorizationFromAyah == null && nullToAbsent
          ? const Value.absent()
          : Value(memorizationFromAyah),
      memorizationToAyah: memorizationToAyah == null && nullToAbsent
          ? const Value.absent()
          : Value(memorizationToAyah),
      revisionSurahId: revisionSurahId == null && nullToAbsent
          ? const Value.absent()
          : Value(revisionSurahId),
      revisionFromAyah: revisionFromAyah == null && nullToAbsent
          ? const Value.absent()
          : Value(revisionFromAyah),
      revisionToAyah: revisionToAyah == null && nullToAbsent
          ? const Value.absent()
          : Value(revisionToAyah),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
    );
  }

  factory Schedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Schedule(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      date: serializer.fromJson<DateTime>(json['date']),
      time: serializer.fromJson<String>(json['time']),
      memorizationSurahId:
          serializer.fromJson<int?>(json['memorizationSurahId']),
      memorizationFromAyah:
          serializer.fromJson<int?>(json['memorizationFromAyah']),
      memorizationToAyah: serializer.fromJson<int?>(json['memorizationToAyah']),
      revisionSurahId: serializer.fromJson<int?>(json['revisionSurahId']),
      revisionFromAyah: serializer.fromJson<int?>(json['revisionFromAyah']),
      revisionToAyah: serializer.fromJson<int?>(json['revisionToAyah']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'date': serializer.toJson<DateTime>(date),
      'time': serializer.toJson<String>(time),
      'memorizationSurahId': serializer.toJson<int?>(memorizationSurahId),
      'memorizationFromAyah': serializer.toJson<int?>(memorizationFromAyah),
      'memorizationToAyah': serializer.toJson<int?>(memorizationToAyah),
      'revisionSurahId': serializer.toJson<int?>(revisionSurahId),
      'revisionFromAyah': serializer.toJson<int?>(revisionFromAyah),
      'revisionToAyah': serializer.toJson<int?>(revisionToAyah),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Schedule copyWith(
          {int? id,
          int? studentId,
          DateTime? date,
          String? time,
          Value<int?> memorizationSurahId = const Value.absent(),
          Value<int?> memorizationFromAyah = const Value.absent(),
          Value<int?> memorizationToAyah = const Value.absent(),
          Value<int?> revisionSurahId = const Value.absent(),
          Value<int?> revisionFromAyah = const Value.absent(),
          Value<int?> revisionToAyah = const Value.absent(),
          bool? isCompleted,
          DateTime? createdAt}) =>
      Schedule(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        date: date ?? this.date,
        time: time ?? this.time,
        memorizationSurahId: memorizationSurahId.present
            ? memorizationSurahId.value
            : this.memorizationSurahId,
        memorizationFromAyah: memorizationFromAyah.present
            ? memorizationFromAyah.value
            : this.memorizationFromAyah,
        memorizationToAyah: memorizationToAyah.present
            ? memorizationToAyah.value
            : this.memorizationToAyah,
        revisionSurahId: revisionSurahId.present
            ? revisionSurahId.value
            : this.revisionSurahId,
        revisionFromAyah: revisionFromAyah.present
            ? revisionFromAyah.value
            : this.revisionFromAyah,
        revisionToAyah:
            revisionToAyah.present ? revisionToAyah.value : this.revisionToAyah,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
      );
  Schedule copyWithCompanion(SchedulesCompanion data) {
    return Schedule(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      memorizationSurahId: data.memorizationSurahId.present
          ? data.memorizationSurahId.value
          : this.memorizationSurahId,
      memorizationFromAyah: data.memorizationFromAyah.present
          ? data.memorizationFromAyah.value
          : this.memorizationFromAyah,
      memorizationToAyah: data.memorizationToAyah.present
          ? data.memorizationToAyah.value
          : this.memorizationToAyah,
      revisionSurahId: data.revisionSurahId.present
          ? data.revisionSurahId.value
          : this.revisionSurahId,
      revisionFromAyah: data.revisionFromAyah.present
          ? data.revisionFromAyah.value
          : this.revisionFromAyah,
      revisionToAyah: data.revisionToAyah.present
          ? data.revisionToAyah.value
          : this.revisionToAyah,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Schedule(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('memorizationSurahId: $memorizationSurahId, ')
          ..write('memorizationFromAyah: $memorizationFromAyah, ')
          ..write('memorizationToAyah: $memorizationToAyah, ')
          ..write('revisionSurahId: $revisionSurahId, ')
          ..write('revisionFromAyah: $revisionFromAyah, ')
          ..write('revisionToAyah: $revisionToAyah, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      studentId,
      date,
      time,
      memorizationSurahId,
      memorizationFromAyah,
      memorizationToAyah,
      revisionSurahId,
      revisionFromAyah,
      revisionToAyah,
      isCompleted,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Schedule &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.date == this.date &&
          other.time == this.time &&
          other.memorizationSurahId == this.memorizationSurahId &&
          other.memorizationFromAyah == this.memorizationFromAyah &&
          other.memorizationToAyah == this.memorizationToAyah &&
          other.revisionSurahId == this.revisionSurahId &&
          other.revisionFromAyah == this.revisionFromAyah &&
          other.revisionToAyah == this.revisionToAyah &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt);
}

class SchedulesCompanion extends UpdateCompanion<Schedule> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<DateTime> date;
  final Value<String> time;
  final Value<int?> memorizationSurahId;
  final Value<int?> memorizationFromAyah;
  final Value<int?> memorizationToAyah;
  final Value<int?> revisionSurahId;
  final Value<int?> revisionFromAyah;
  final Value<int?> revisionToAyah;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  const SchedulesCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.memorizationSurahId = const Value.absent(),
    this.memorizationFromAyah = const Value.absent(),
    this.memorizationToAyah = const Value.absent(),
    this.revisionSurahId = const Value.absent(),
    this.revisionFromAyah = const Value.absent(),
    this.revisionToAyah = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required DateTime date,
    required String time,
    this.memorizationSurahId = const Value.absent(),
    this.memorizationFromAyah = const Value.absent(),
    this.memorizationToAyah = const Value.absent(),
    this.revisionSurahId = const Value.absent(),
    this.revisionFromAyah = const Value.absent(),
    this.revisionToAyah = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : studentId = Value(studentId),
        date = Value(date),
        time = Value(time);
  static Insertable<Schedule> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<DateTime>? date,
    Expression<String>? time,
    Expression<int>? memorizationSurahId,
    Expression<int>? memorizationFromAyah,
    Expression<int>? memorizationToAyah,
    Expression<int>? revisionSurahId,
    Expression<int>? revisionFromAyah,
    Expression<int>? revisionToAyah,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (memorizationSurahId != null)
        'memorization_surah_id': memorizationSurahId,
      if (memorizationFromAyah != null)
        'memorization_from_ayah': memorizationFromAyah,
      if (memorizationToAyah != null)
        'memorization_to_ayah': memorizationToAyah,
      if (revisionSurahId != null) 'revision_surah_id': revisionSurahId,
      if (revisionFromAyah != null) 'revision_from_ayah': revisionFromAyah,
      if (revisionToAyah != null) 'revision_to_ayah': revisionToAyah,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SchedulesCompanion copyWith(
      {Value<int>? id,
      Value<int>? studentId,
      Value<DateTime>? date,
      Value<String>? time,
      Value<int?>? memorizationSurahId,
      Value<int?>? memorizationFromAyah,
      Value<int?>? memorizationToAyah,
      Value<int?>? revisionSurahId,
      Value<int?>? revisionFromAyah,
      Value<int?>? revisionToAyah,
      Value<bool>? isCompleted,
      Value<DateTime>? createdAt}) {
    return SchedulesCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      time: time ?? this.time,
      memorizationSurahId: memorizationSurahId ?? this.memorizationSurahId,
      memorizationFromAyah: memorizationFromAyah ?? this.memorizationFromAyah,
      memorizationToAyah: memorizationToAyah ?? this.memorizationToAyah,
      revisionSurahId: revisionSurahId ?? this.revisionSurahId,
      revisionFromAyah: revisionFromAyah ?? this.revisionFromAyah,
      revisionToAyah: revisionToAyah ?? this.revisionToAyah,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (memorizationSurahId.present) {
      map['memorization_surah_id'] = Variable<int>(memorizationSurahId.value);
    }
    if (memorizationFromAyah.present) {
      map['memorization_from_ayah'] = Variable<int>(memorizationFromAyah.value);
    }
    if (memorizationToAyah.present) {
      map['memorization_to_ayah'] = Variable<int>(memorizationToAyah.value);
    }
    if (revisionSurahId.present) {
      map['revision_surah_id'] = Variable<int>(revisionSurahId.value);
    }
    if (revisionFromAyah.present) {
      map['revision_from_ayah'] = Variable<int>(revisionFromAyah.value);
    }
    if (revisionToAyah.present) {
      map['revision_to_ayah'] = Variable<int>(revisionToAyah.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('memorizationSurahId: $memorizationSurahId, ')
          ..write('memorizationFromAyah: $memorizationFromAyah, ')
          ..write('memorizationToAyah: $memorizationToAyah, ')
          ..write('revisionSurahId: $revisionSurahId, ')
          ..write('revisionFromAyah: $revisionFromAyah, ')
          ..write('revisionToAyah: $revisionToAyah, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalTypeMeta =
      const VerificationMeta('goalType');
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
      'goal_type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('سورة'));
  static const VerificationMeta _targetSurahIdMeta =
      const VerificationMeta('targetSurahId');
  @override
  late final GeneratedColumn<int> targetSurahId = GeneratedColumn<int>(
      'target_surah_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _targetJuzNumberMeta =
      const VerificationMeta('targetJuzNumber');
  @override
  late final GeneratedColumn<int> targetJuzNumber = GeneratedColumn<int>(
      'target_juz_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
      'target_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('لم يبدأ'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        title,
        goalType,
        targetSurahId,
        targetJuzNumber,
        startDate,
        targetDate,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<Goal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('goal_type')) {
      context.handle(_goalTypeMeta,
          goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta));
    }
    if (data.containsKey('target_surah_id')) {
      context.handle(
          _targetSurahIdMeta,
          targetSurahId.isAcceptableOrUnknown(
              data['target_surah_id']!, _targetSurahIdMeta));
    }
    if (data.containsKey('target_juz_number')) {
      context.handle(
          _targetJuzNumberMeta,
          targetJuzNumber.isAcceptableOrUnknown(
              data['target_juz_number']!, _targetJuzNumberMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      goalType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_type'])!,
      targetSurahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_surah_id']),
      targetJuzNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_juz_number']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}target_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final int id;
  final int studentId;
  final String title;
  final String goalType;
  final int? targetSurahId;
  final int? targetJuzNumber;
  final DateTime startDate;
  final DateTime? targetDate;
  final String status;
  final DateTime createdAt;
  const Goal(
      {required this.id,
      required this.studentId,
      required this.title,
      required this.goalType,
      this.targetSurahId,
      this.targetJuzNumber,
      required this.startDate,
      this.targetDate,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['title'] = Variable<String>(title);
    map['goal_type'] = Variable<String>(goalType);
    if (!nullToAbsent || targetSurahId != null) {
      map['target_surah_id'] = Variable<int>(targetSurahId);
    }
    if (!nullToAbsent || targetJuzNumber != null) {
      map['target_juz_number'] = Variable<int>(targetJuzNumber);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      title: Value(title),
      goalType: Value(goalType),
      targetSurahId: targetSurahId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSurahId),
      targetJuzNumber: targetJuzNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(targetJuzNumber),
      startDate: Value(startDate),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Goal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      title: serializer.fromJson<String>(json['title']),
      goalType: serializer.fromJson<String>(json['goalType']),
      targetSurahId: serializer.fromJson<int?>(json['targetSurahId']),
      targetJuzNumber: serializer.fromJson<int?>(json['targetJuzNumber']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'title': serializer.toJson<String>(title),
      'goalType': serializer.toJson<String>(goalType),
      'targetSurahId': serializer.toJson<int?>(targetSurahId),
      'targetJuzNumber': serializer.toJson<int?>(targetJuzNumber),
      'startDate': serializer.toJson<DateTime>(startDate),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Goal copyWith(
          {int? id,
          int? studentId,
          String? title,
          String? goalType,
          Value<int?> targetSurahId = const Value.absent(),
          Value<int?> targetJuzNumber = const Value.absent(),
          DateTime? startDate,
          Value<DateTime?> targetDate = const Value.absent(),
          String? status,
          DateTime? createdAt}) =>
      Goal(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        title: title ?? this.title,
        goalType: goalType ?? this.goalType,
        targetSurahId:
            targetSurahId.present ? targetSurahId.value : this.targetSurahId,
        targetJuzNumber: targetJuzNumber.present
            ? targetJuzNumber.value
            : this.targetJuzNumber,
        startDate: startDate ?? this.startDate,
        targetDate: targetDate.present ? targetDate.value : this.targetDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      title: data.title.present ? data.title.value : this.title,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      targetSurahId: data.targetSurahId.present
          ? data.targetSurahId.value
          : this.targetSurahId,
      targetJuzNumber: data.targetJuzNumber.present
          ? data.targetJuzNumber.value
          : this.targetJuzNumber,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      targetDate:
          data.targetDate.present ? data.targetDate.value : this.targetDate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('title: $title, ')
          ..write('goalType: $goalType, ')
          ..write('targetSurahId: $targetSurahId, ')
          ..write('targetJuzNumber: $targetJuzNumber, ')
          ..write('startDate: $startDate, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, title, goalType, targetSurahId,
      targetJuzNumber, startDate, targetDate, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.title == this.title &&
          other.goalType == this.goalType &&
          other.targetSurahId == this.targetSurahId &&
          other.targetJuzNumber == this.targetJuzNumber &&
          other.startDate == this.startDate &&
          other.targetDate == this.targetDate &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<String> title;
  final Value<String> goalType;
  final Value<int?> targetSurahId;
  final Value<int?> targetJuzNumber;
  final Value<DateTime> startDate;
  final Value<DateTime?> targetDate;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.title = const Value.absent(),
    this.goalType = const Value.absent(),
    this.targetSurahId = const Value.absent(),
    this.targetJuzNumber = const Value.absent(),
    this.startDate = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required String title,
    this.goalType = const Value.absent(),
    this.targetSurahId = const Value.absent(),
    this.targetJuzNumber = const Value.absent(),
    required DateTime startDate,
    this.targetDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : studentId = Value(studentId),
        title = Value(title),
        startDate = Value(startDate);
  static Insertable<Goal> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<String>? title,
    Expression<String>? goalType,
    Expression<int>? targetSurahId,
    Expression<int>? targetJuzNumber,
    Expression<DateTime>? startDate,
    Expression<DateTime>? targetDate,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (title != null) 'title': title,
      if (goalType != null) 'goal_type': goalType,
      if (targetSurahId != null) 'target_surah_id': targetSurahId,
      if (targetJuzNumber != null) 'target_juz_number': targetJuzNumber,
      if (startDate != null) 'start_date': startDate,
      if (targetDate != null) 'target_date': targetDate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GoalsCompanion copyWith(
      {Value<int>? id,
      Value<int>? studentId,
      Value<String>? title,
      Value<String>? goalType,
      Value<int?>? targetSurahId,
      Value<int?>? targetJuzNumber,
      Value<DateTime>? startDate,
      Value<DateTime?>? targetDate,
      Value<String>? status,
      Value<DateTime>? createdAt}) {
    return GoalsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      title: title ?? this.title,
      goalType: goalType ?? this.goalType,
      targetSurahId: targetSurahId ?? this.targetSurahId,
      targetJuzNumber: targetJuzNumber ?? this.targetJuzNumber,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (targetSurahId.present) {
      map['target_surah_id'] = Variable<int>(targetSurahId.value);
    }
    if (targetJuzNumber.present) {
      map['target_juz_number'] = Variable<int>(targetJuzNumber.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('title: $title, ')
          ..write('goalType: $goalType, ')
          ..write('targetSurahId: $targetSurahId, ')
          ..write('targetJuzNumber: $targetJuzNumber, ')
          ..write('startDate: $startDate, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MemorizedRangesTable extends MemorizedRanges
    with TableInfo<$MemorizedRangesTable, MemorizedRange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemorizedRangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _surahIdMeta =
      const VerificationMeta('surahId');
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fromAyahMeta =
      const VerificationMeta('fromAyah');
  @override
  late final GeneratedColumn<int> fromAyah = GeneratedColumn<int>(
      'from_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _toAyahMeta = const VerificationMeta('toAyah');
  @override
  late final GeneratedColumn<int> toAyah = GeneratedColumn<int>(
      'to_ayah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('محفوظ'));
  static const VerificationMeta _revisionCycleDaysMeta =
      const VerificationMeta('revisionCycleDays');
  @override
  late final GeneratedColumn<int> revisionCycleDays = GeneratedColumn<int>(
      'revision_cycle_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(7));
  static const VerificationMeta _lastRevisedAtMeta =
      const VerificationMeta('lastRevisedAt');
  @override
  late final GeneratedColumn<DateTime> lastRevisedAt =
      GeneratedColumn<DateTime>('last_revised_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _nextReviewDateMeta =
      const VerificationMeta('nextReviewDate');
  @override
  late final GeneratedColumn<DateTime> nextReviewDate =
      GeneratedColumn<DateTime>('next_review_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        surahId,
        fromAyah,
        toAyah,
        status,
        revisionCycleDays,
        lastRevisedAt,
        nextReviewDate,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memorized_ranges';
  @override
  VerificationContext validateIntegrity(Insertable<MemorizedRange> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('surah_id')) {
      context.handle(_surahIdMeta,
          surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta));
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('from_ayah')) {
      context.handle(_fromAyahMeta,
          fromAyah.isAcceptableOrUnknown(data['from_ayah']!, _fromAyahMeta));
    } else if (isInserting) {
      context.missing(_fromAyahMeta);
    }
    if (data.containsKey('to_ayah')) {
      context.handle(_toAyahMeta,
          toAyah.isAcceptableOrUnknown(data['to_ayah']!, _toAyahMeta));
    } else if (isInserting) {
      context.missing(_toAyahMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('revision_cycle_days')) {
      context.handle(
          _revisionCycleDaysMeta,
          revisionCycleDays.isAcceptableOrUnknown(
              data['revision_cycle_days']!, _revisionCycleDaysMeta));
    }
    if (data.containsKey('last_revised_at')) {
      context.handle(
          _lastRevisedAtMeta,
          lastRevisedAt.isAcceptableOrUnknown(
              data['last_revised_at']!, _lastRevisedAtMeta));
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
          _nextReviewDateMeta,
          nextReviewDate.isAcceptableOrUnknown(
              data['next_review_date']!, _nextReviewDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemorizedRange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemorizedRange(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      surahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_id'])!,
      fromAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_ayah'])!,
      toAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_ayah'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      revisionCycleDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}revision_cycle_days'])!,
      lastRevisedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_revised_at']),
      nextReviewDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_review_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MemorizedRangesTable createAlias(String alias) {
    return $MemorizedRangesTable(attachedDatabase, alias);
  }
}

class MemorizedRange extends DataClass implements Insertable<MemorizedRange> {
  final int id;
  final int studentId;
  final int surahId;
  final int fromAyah;
  final int toAyah;
  final String status;
  final int revisionCycleDays;
  final DateTime? lastRevisedAt;
  final DateTime? nextReviewDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MemorizedRange(
      {required this.id,
      required this.studentId,
      required this.surahId,
      required this.fromAyah,
      required this.toAyah,
      required this.status,
      required this.revisionCycleDays,
      this.lastRevisedAt,
      this.nextReviewDate,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['surah_id'] = Variable<int>(surahId);
    map['from_ayah'] = Variable<int>(fromAyah);
    map['to_ayah'] = Variable<int>(toAyah);
    map['status'] = Variable<String>(status);
    map['revision_cycle_days'] = Variable<int>(revisionCycleDays);
    if (!nullToAbsent || lastRevisedAt != null) {
      map['last_revised_at'] = Variable<DateTime>(lastRevisedAt);
    }
    if (!nullToAbsent || nextReviewDate != null) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MemorizedRangesCompanion toCompanion(bool nullToAbsent) {
    return MemorizedRangesCompanion(
      id: Value(id),
      studentId: Value(studentId),
      surahId: Value(surahId),
      fromAyah: Value(fromAyah),
      toAyah: Value(toAyah),
      status: Value(status),
      revisionCycleDays: Value(revisionCycleDays),
      lastRevisedAt: lastRevisedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRevisedAt),
      nextReviewDate: nextReviewDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MemorizedRange.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemorizedRange(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      surahId: serializer.fromJson<int>(json['surahId']),
      fromAyah: serializer.fromJson<int>(json['fromAyah']),
      toAyah: serializer.fromJson<int>(json['toAyah']),
      status: serializer.fromJson<String>(json['status']),
      revisionCycleDays: serializer.fromJson<int>(json['revisionCycleDays']),
      lastRevisedAt: serializer.fromJson<DateTime?>(json['lastRevisedAt']),
      nextReviewDate: serializer.fromJson<DateTime?>(json['nextReviewDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'surahId': serializer.toJson<int>(surahId),
      'fromAyah': serializer.toJson<int>(fromAyah),
      'toAyah': serializer.toJson<int>(toAyah),
      'status': serializer.toJson<String>(status),
      'revisionCycleDays': serializer.toJson<int>(revisionCycleDays),
      'lastRevisedAt': serializer.toJson<DateTime?>(lastRevisedAt),
      'nextReviewDate': serializer.toJson<DateTime?>(nextReviewDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MemorizedRange copyWith(
          {int? id,
          int? studentId,
          int? surahId,
          int? fromAyah,
          int? toAyah,
          String? status,
          int? revisionCycleDays,
          Value<DateTime?> lastRevisedAt = const Value.absent(),
          Value<DateTime?> nextReviewDate = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MemorizedRange(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        surahId: surahId ?? this.surahId,
        fromAyah: fromAyah ?? this.fromAyah,
        toAyah: toAyah ?? this.toAyah,
        status: status ?? this.status,
        revisionCycleDays: revisionCycleDays ?? this.revisionCycleDays,
        lastRevisedAt:
            lastRevisedAt.present ? lastRevisedAt.value : this.lastRevisedAt,
        nextReviewDate:
            nextReviewDate.present ? nextReviewDate.value : this.nextReviewDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MemorizedRange copyWithCompanion(MemorizedRangesCompanion data) {
    return MemorizedRange(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      fromAyah: data.fromAyah.present ? data.fromAyah.value : this.fromAyah,
      toAyah: data.toAyah.present ? data.toAyah.value : this.toAyah,
      status: data.status.present ? data.status.value : this.status,
      revisionCycleDays: data.revisionCycleDays.present
          ? data.revisionCycleDays.value
          : this.revisionCycleDays,
      lastRevisedAt: data.lastRevisedAt.present
          ? data.lastRevisedAt.value
          : this.lastRevisedAt,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemorizedRange(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('surahId: $surahId, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toAyah: $toAyah, ')
          ..write('status: $status, ')
          ..write('revisionCycleDays: $revisionCycleDays, ')
          ..write('lastRevisedAt: $lastRevisedAt, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      studentId,
      surahId,
      fromAyah,
      toAyah,
      status,
      revisionCycleDays,
      lastRevisedAt,
      nextReviewDate,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemorizedRange &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.surahId == this.surahId &&
          other.fromAyah == this.fromAyah &&
          other.toAyah == this.toAyah &&
          other.status == this.status &&
          other.revisionCycleDays == this.revisionCycleDays &&
          other.lastRevisedAt == this.lastRevisedAt &&
          other.nextReviewDate == this.nextReviewDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MemorizedRangesCompanion extends UpdateCompanion<MemorizedRange> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<int> surahId;
  final Value<int> fromAyah;
  final Value<int> toAyah;
  final Value<String> status;
  final Value<int> revisionCycleDays;
  final Value<DateTime?> lastRevisedAt;
  final Value<DateTime?> nextReviewDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MemorizedRangesCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.surahId = const Value.absent(),
    this.fromAyah = const Value.absent(),
    this.toAyah = const Value.absent(),
    this.status = const Value.absent(),
    this.revisionCycleDays = const Value.absent(),
    this.lastRevisedAt = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MemorizedRangesCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required int surahId,
    required int fromAyah,
    required int toAyah,
    this.status = const Value.absent(),
    this.revisionCycleDays = const Value.absent(),
    this.lastRevisedAt = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : studentId = Value(studentId),
        surahId = Value(surahId),
        fromAyah = Value(fromAyah),
        toAyah = Value(toAyah);
  static Insertable<MemorizedRange> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<int>? surahId,
    Expression<int>? fromAyah,
    Expression<int>? toAyah,
    Expression<String>? status,
    Expression<int>? revisionCycleDays,
    Expression<DateTime>? lastRevisedAt,
    Expression<DateTime>? nextReviewDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (surahId != null) 'surah_id': surahId,
      if (fromAyah != null) 'from_ayah': fromAyah,
      if (toAyah != null) 'to_ayah': toAyah,
      if (status != null) 'status': status,
      if (revisionCycleDays != null) 'revision_cycle_days': revisionCycleDays,
      if (lastRevisedAt != null) 'last_revised_at': lastRevisedAt,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MemorizedRangesCompanion copyWith(
      {Value<int>? id,
      Value<int>? studentId,
      Value<int>? surahId,
      Value<int>? fromAyah,
      Value<int>? toAyah,
      Value<String>? status,
      Value<int>? revisionCycleDays,
      Value<DateTime?>? lastRevisedAt,
      Value<DateTime?>? nextReviewDate,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MemorizedRangesCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      surahId: surahId ?? this.surahId,
      fromAyah: fromAyah ?? this.fromAyah,
      toAyah: toAyah ?? this.toAyah,
      status: status ?? this.status,
      revisionCycleDays: revisionCycleDays ?? this.revisionCycleDays,
      lastRevisedAt: lastRevisedAt ?? this.lastRevisedAt,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (fromAyah.present) {
      map['from_ayah'] = Variable<int>(fromAyah.value);
    }
    if (toAyah.present) {
      map['to_ayah'] = Variable<int>(toAyah.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (revisionCycleDays.present) {
      map['revision_cycle_days'] = Variable<int>(revisionCycleDays.value);
    }
    if (lastRevisedAt.present) {
      map['last_revised_at'] = Variable<DateTime>(lastRevisedAt.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemorizedRangesCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('surahId: $surahId, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toAyah: $toAyah, ')
          ..write('status: $status, ')
          ..write('revisionCycleDays: $revisionCycleDays, ')
          ..write('lastRevisedAt: $lastRevisedAt, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PendingChangesTable extends PendingChanges
    with TableInfo<$PendingChangesTable, PendingChange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityLocalIdMeta =
      const VerificationMeta('entityLocalId');
  @override
  late final GeneratedColumn<int> entityLocalId = GeneratedColumn<int>(
      'entity_local_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityLocalId,
        operation,
        payload,
        createdAt,
        retryCount,
        lastError
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_changes';
  @override
  VerificationContext validateIntegrity(Insertable<PendingChange> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_local_id')) {
      context.handle(
          _entityLocalIdMeta,
          entityLocalId.isAcceptableOrUnknown(
              data['entity_local_id']!, _entityLocalIdMeta));
    } else if (isInserting) {
      context.missing(_entityLocalIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingChange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingChange(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityLocalId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_local_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
    );
  }

  @override
  $PendingChangesTable createAlias(String alias) {
    return $PendingChangesTable(attachedDatabase, alias);
  }
}

class PendingChange extends DataClass implements Insertable<PendingChange> {
  final int id;
  final String entityType;
  final int entityLocalId;
  final String operation;
  final String payload;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;
  const PendingChange(
      {required this.id,
      required this.entityType,
      required this.entityLocalId,
      required this.operation,
      required this.payload,
      required this.createdAt,
      required this.retryCount,
      this.lastError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_local_id'] = Variable<int>(entityLocalId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  PendingChangesCompanion toCompanion(bool nullToAbsent) {
    return PendingChangesCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityLocalId: Value(entityLocalId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory PendingChange.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingChange(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityLocalId: serializer.fromJson<int>(json['entityLocalId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityLocalId': serializer.toJson<int>(entityLocalId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  PendingChange copyWith(
          {int? id,
          String? entityType,
          int? entityLocalId,
          String? operation,
          String? payload,
          DateTime? createdAt,
          int? retryCount,
          Value<String?> lastError = const Value.absent()}) =>
      PendingChange(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityLocalId: entityLocalId ?? this.entityLocalId,
        operation: operation ?? this.operation,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        retryCount: retryCount ?? this.retryCount,
        lastError: lastError.present ? lastError.value : this.lastError,
      );
  PendingChange copyWithCompanion(PendingChangesCompanion data) {
    return PendingChange(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityLocalId: data.entityLocalId.present
          ? data.entityLocalId.value
          : this.entityLocalId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingChange(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityLocalId: $entityLocalId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityLocalId, operation,
      payload, createdAt, retryCount, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingChange &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityLocalId == this.entityLocalId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError);
}

class PendingChangesCompanion extends UpdateCompanion<PendingChange> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int> entityLocalId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> lastError;
  const PendingChangesCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityLocalId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  PendingChangesCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required int entityLocalId,
    required String operation,
    required String payload,
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
  })  : entityType = Value(entityType),
        entityLocalId = Value(entityLocalId),
        operation = Value(operation),
        payload = Value(payload);
  static Insertable<PendingChange> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? entityLocalId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityLocalId != null) 'entity_local_id': entityLocalId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
    });
  }

  PendingChangesCompanion copyWith(
      {Value<int>? id,
      Value<String>? entityType,
      Value<int>? entityLocalId,
      Value<String>? operation,
      Value<String>? payload,
      Value<DateTime>? createdAt,
      Value<int>? retryCount,
      Value<String?>? lastError}) {
    return PendingChangesCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityLocalId: entityLocalId ?? this.entityLocalId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityLocalId.present) {
      map['entity_local_id'] = Variable<int>(entityLocalId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingChangesCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityLocalId: $entityLocalId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $JuzSurahRangesTable juzSurahRanges = $JuzSurahRangesTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SessionMemorizationsTable sessionMemorizations =
      $SessionMemorizationsTable(this);
  late final $SessionRevisionsTable sessionRevisions =
      $SessionRevisionsTable(this);
  late final $SessionEvaluationsTable sessionEvaluations =
      $SessionEvaluationsTable(this);
  late final $SchedulesTable schedules = $SchedulesTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $MemorizedRangesTable memorizedRanges =
      $MemorizedRangesTable(this);
  late final $PendingChangesTable pendingChanges = $PendingChangesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        surahs,
        juzSurahRanges,
        students,
        sessions,
        sessionMemorizations,
        sessionRevisions,
        sessionEvaluations,
        schedules,
        goals,
        memorizedRanges,
        pendingChanges
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  required String passwordHash,
  required String fullName,
  Value<String> role,
  Value<DateTime> createdAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> passwordHash,
  Value<String> fullName,
  Value<String> role,
  Value<DateTime> createdAt,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            passwordHash: passwordHash,
            fullName: fullName,
            role: role,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String passwordHash,
            required String fullName,
            Value<String> role = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            passwordHash: passwordHash,
            fullName: fullName,
            role: role,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$SurahsTableCreateCompanionBuilder = SurahsCompanion Function({
  Value<int> id,
  required int number,
  required String name,
  required int ayahCount,
});
typedef $$SurahsTableUpdateCompanionBuilder = SurahsCompanion Function({
  Value<int> id,
  Value<int> number,
  Value<String> name,
  Value<int> ayahCount,
});

class $$SurahsTableFilterComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ayahCount => $composableBuilder(
      column: $table.ayahCount, builder: (column) => ColumnFilters(column));
}

class $$SurahsTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ayahCount => $composableBuilder(
      column: $table.ayahCount, builder: (column) => ColumnOrderings(column));
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get ayahCount =>
      $composableBuilder(column: $table.ayahCount, builder: (column) => column);
}

class $$SurahsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SurahsTable,
    Surah,
    $$SurahsTableFilterComposer,
    $$SurahsTableOrderingComposer,
    $$SurahsTableAnnotationComposer,
    $$SurahsTableCreateCompanionBuilder,
    $$SurahsTableUpdateCompanionBuilder,
    (Surah, BaseReferences<_$AppDatabase, $SurahsTable, Surah>),
    Surah,
    PrefetchHooks Function()> {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> number = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> ayahCount = const Value.absent(),
          }) =>
              SurahsCompanion(
            id: id,
            number: number,
            name: name,
            ayahCount: ayahCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int number,
            required String name,
            required int ayahCount,
          }) =>
              SurahsCompanion.insert(
            id: id,
            number: number,
            name: name,
            ayahCount: ayahCount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SurahsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SurahsTable,
    Surah,
    $$SurahsTableFilterComposer,
    $$SurahsTableOrderingComposer,
    $$SurahsTableAnnotationComposer,
    $$SurahsTableCreateCompanionBuilder,
    $$SurahsTableUpdateCompanionBuilder,
    (Surah, BaseReferences<_$AppDatabase, $SurahsTable, Surah>),
    Surah,
    PrefetchHooks Function()>;
typedef $$JuzSurahRangesTableCreateCompanionBuilder = JuzSurahRangesCompanion
    Function({
  Value<int> id,
  required int juzNumber,
  required int surahId,
  required int fromAyah,
  required int toAyah,
});
typedef $$JuzSurahRangesTableUpdateCompanionBuilder = JuzSurahRangesCompanion
    Function({
  Value<int> id,
  Value<int> juzNumber,
  Value<int> surahId,
  Value<int> fromAyah,
  Value<int> toAyah,
});

class $$JuzSurahRangesTableFilterComposer
    extends Composer<_$AppDatabase, $JuzSurahRangesTable> {
  $$JuzSurahRangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get juzNumber => $composableBuilder(
      column: $table.juzNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnFilters(column));
}

class $$JuzSurahRangesTableOrderingComposer
    extends Composer<_$AppDatabase, $JuzSurahRangesTable> {
  $$JuzSurahRangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get juzNumber => $composableBuilder(
      column: $table.juzNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnOrderings(column));
}

class $$JuzSurahRangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JuzSurahRangesTable> {
  $$JuzSurahRangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get juzNumber =>
      $composableBuilder(column: $table.juzNumber, builder: (column) => column);

  GeneratedColumn<int> get surahId =>
      $composableBuilder(column: $table.surahId, builder: (column) => column);

  GeneratedColumn<int> get fromAyah =>
      $composableBuilder(column: $table.fromAyah, builder: (column) => column);

  GeneratedColumn<int> get toAyah =>
      $composableBuilder(column: $table.toAyah, builder: (column) => column);
}

class $$JuzSurahRangesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JuzSurahRangesTable,
    JuzSurahRange,
    $$JuzSurahRangesTableFilterComposer,
    $$JuzSurahRangesTableOrderingComposer,
    $$JuzSurahRangesTableAnnotationComposer,
    $$JuzSurahRangesTableCreateCompanionBuilder,
    $$JuzSurahRangesTableUpdateCompanionBuilder,
    (
      JuzSurahRange,
      BaseReferences<_$AppDatabase, $JuzSurahRangesTable, JuzSurahRange>
    ),
    JuzSurahRange,
    PrefetchHooks Function()> {
  $$JuzSurahRangesTableTableManager(
      _$AppDatabase db, $JuzSurahRangesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JuzSurahRangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JuzSurahRangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JuzSurahRangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> juzNumber = const Value.absent(),
            Value<int> surahId = const Value.absent(),
            Value<int> fromAyah = const Value.absent(),
            Value<int> toAyah = const Value.absent(),
          }) =>
              JuzSurahRangesCompanion(
            id: id,
            juzNumber: juzNumber,
            surahId: surahId,
            fromAyah: fromAyah,
            toAyah: toAyah,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int juzNumber,
            required int surahId,
            required int fromAyah,
            required int toAyah,
          }) =>
              JuzSurahRangesCompanion.insert(
            id: id,
            juzNumber: juzNumber,
            surahId: surahId,
            fromAyah: fromAyah,
            toAyah: toAyah,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JuzSurahRangesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JuzSurahRangesTable,
    JuzSurahRange,
    $$JuzSurahRangesTableFilterComposer,
    $$JuzSurahRangesTableOrderingComposer,
    $$JuzSurahRangesTableAnnotationComposer,
    $$JuzSurahRangesTableCreateCompanionBuilder,
    $$JuzSurahRangesTableUpdateCompanionBuilder,
    (
      JuzSurahRange,
      BaseReferences<_$AppDatabase, $JuzSurahRangesTable, JuzSurahRange>
    ),
    JuzSurahRange,
    PrefetchHooks Function()>;
typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  Value<int> id,
  required String fullName,
  required int age,
  required String phone,
  required String address,
  Value<String?> parentName,
  Value<String?> parentPhone,
  Value<int?> currentSurahId,
  Value<int?> lastCompletedSurahId,
  Value<int> totalCompletedJuz,
  Value<String> level,
  Value<DateTime> createdAt,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<int> id,
  Value<String> fullName,
  Value<int> age,
  Value<String> phone,
  Value<String> address,
  Value<String?> parentName,
  Value<String?> parentPhone,
  Value<int?> currentSurahId,
  Value<int?> lastCompletedSurahId,
  Value<int> totalCompletedJuz,
  Value<String> level,
  Value<DateTime> createdAt,
});

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentName => $composableBuilder(
      column: $table.parentName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentPhone => $composableBuilder(
      column: $table.parentPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentSurahId => $composableBuilder(
      column: $table.currentSurahId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastCompletedSurahId => $composableBuilder(
      column: $table.lastCompletedSurahId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCompletedJuz => $composableBuilder(
      column: $table.totalCompletedJuz,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentName => $composableBuilder(
      column: $table.parentName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentPhone => $composableBuilder(
      column: $table.parentPhone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentSurahId => $composableBuilder(
      column: $table.currentSurahId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastCompletedSurahId => $composableBuilder(
      column: $table.lastCompletedSurahId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCompletedJuz => $composableBuilder(
      column: $table.totalCompletedJuz,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get parentName => $composableBuilder(
      column: $table.parentName, builder: (column) => column);

  GeneratedColumn<String> get parentPhone => $composableBuilder(
      column: $table.parentPhone, builder: (column) => column);

  GeneratedColumn<int> get currentSurahId => $composableBuilder(
      column: $table.currentSurahId, builder: (column) => column);

  GeneratedColumn<int> get lastCompletedSurahId => $composableBuilder(
      column: $table.lastCompletedSurahId, builder: (column) => column);

  GeneratedColumn<int> get totalCompletedJuz => $composableBuilder(
      column: $table.totalCompletedJuz, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StudentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()> {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<int> age = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String?> parentName = const Value.absent(),
            Value<String?> parentPhone = const Value.absent(),
            Value<int?> currentSurahId = const Value.absent(),
            Value<int?> lastCompletedSurahId = const Value.absent(),
            Value<int> totalCompletedJuz = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              StudentsCompanion(
            id: id,
            fullName: fullName,
            age: age,
            phone: phone,
            address: address,
            parentName: parentName,
            parentPhone: parentPhone,
            currentSurahId: currentSurahId,
            lastCompletedSurahId: lastCompletedSurahId,
            totalCompletedJuz: totalCompletedJuz,
            level: level,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String fullName,
            required int age,
            required String phone,
            required String address,
            Value<String?> parentName = const Value.absent(),
            Value<String?> parentPhone = const Value.absent(),
            Value<int?> currentSurahId = const Value.absent(),
            Value<int?> lastCompletedSurahId = const Value.absent(),
            Value<int> totalCompletedJuz = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              StudentsCompanion.insert(
            id: id,
            fullName: fullName,
            age: age,
            phone: phone,
            address: address,
            parentName: parentName,
            parentPhone: parentPhone,
            currentSurahId: currentSurahId,
            lastCompletedSurahId: lastCompletedSurahId,
            totalCompletedJuz: totalCompletedJuz,
            level: level,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()>;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required int studentId,
  required DateTime date,
  required String time,
  Value<String> attendanceStatus,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int> studentId,
  Value<DateTime> date,
  Value<String> time,
  Value<String> attendanceStatus,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attendanceStatus => $composableBuilder(
      column: $table.attendanceStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attendanceStatus => $composableBuilder(
      column: $table.attendanceStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get attendanceStatus => $composableBuilder(
      column: $table.attendanceStatus, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
    Session,
    PrefetchHooks Function()> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> time = const Value.absent(),
            Value<String> attendanceStatus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            studentId: studentId,
            date: date,
            time: time,
            attendanceStatus: attendanceStatus,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int studentId,
            required DateTime date,
            required String time,
            Value<String> attendanceStatus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SessionsCompanion.insert(
            id: id,
            studentId: studentId,
            date: date,
            time: time,
            attendanceStatus: attendanceStatus,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
    Session,
    PrefetchHooks Function()>;
typedef $$SessionMemorizationsTableCreateCompanionBuilder
    = SessionMemorizationsCompanion Function({
  Value<int> id,
  required int sessionId,
  required int surahId,
  required int fromAyah,
  required int toAyah,
});
typedef $$SessionMemorizationsTableUpdateCompanionBuilder
    = SessionMemorizationsCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> surahId,
  Value<int> fromAyah,
  Value<int> toAyah,
});

class $$SessionMemorizationsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionMemorizationsTable> {
  $$SessionMemorizationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnFilters(column));
}

class $$SessionMemorizationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionMemorizationsTable> {
  $$SessionMemorizationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnOrderings(column));
}

class $$SessionMemorizationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionMemorizationsTable> {
  $$SessionMemorizationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get surahId =>
      $composableBuilder(column: $table.surahId, builder: (column) => column);

  GeneratedColumn<int> get fromAyah =>
      $composableBuilder(column: $table.fromAyah, builder: (column) => column);

  GeneratedColumn<int> get toAyah =>
      $composableBuilder(column: $table.toAyah, builder: (column) => column);
}

class $$SessionMemorizationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionMemorizationsTable,
    SessionMemorization,
    $$SessionMemorizationsTableFilterComposer,
    $$SessionMemorizationsTableOrderingComposer,
    $$SessionMemorizationsTableAnnotationComposer,
    $$SessionMemorizationsTableCreateCompanionBuilder,
    $$SessionMemorizationsTableUpdateCompanionBuilder,
    (
      SessionMemorization,
      BaseReferences<_$AppDatabase, $SessionMemorizationsTable,
          SessionMemorization>
    ),
    SessionMemorization,
    PrefetchHooks Function()> {
  $$SessionMemorizationsTableTableManager(
      _$AppDatabase db, $SessionMemorizationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionMemorizationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionMemorizationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionMemorizationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> surahId = const Value.absent(),
            Value<int> fromAyah = const Value.absent(),
            Value<int> toAyah = const Value.absent(),
          }) =>
              SessionMemorizationsCompanion(
            id: id,
            sessionId: sessionId,
            surahId: surahId,
            fromAyah: fromAyah,
            toAyah: toAyah,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int surahId,
            required int fromAyah,
            required int toAyah,
          }) =>
              SessionMemorizationsCompanion.insert(
            id: id,
            sessionId: sessionId,
            surahId: surahId,
            fromAyah: fromAyah,
            toAyah: toAyah,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionMemorizationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SessionMemorizationsTable,
        SessionMemorization,
        $$SessionMemorizationsTableFilterComposer,
        $$SessionMemorizationsTableOrderingComposer,
        $$SessionMemorizationsTableAnnotationComposer,
        $$SessionMemorizationsTableCreateCompanionBuilder,
        $$SessionMemorizationsTableUpdateCompanionBuilder,
        (
          SessionMemorization,
          BaseReferences<_$AppDatabase, $SessionMemorizationsTable,
              SessionMemorization>
        ),
        SessionMemorization,
        PrefetchHooks Function()>;
typedef $$SessionRevisionsTableCreateCompanionBuilder
    = SessionRevisionsCompanion Function({
  Value<int> id,
  required int sessionId,
  required int surahId,
  required int fromAyah,
  required int toAyah,
});
typedef $$SessionRevisionsTableUpdateCompanionBuilder
    = SessionRevisionsCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> surahId,
  Value<int> fromAyah,
  Value<int> toAyah,
});

class $$SessionRevisionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionRevisionsTable> {
  $$SessionRevisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnFilters(column));
}

class $$SessionRevisionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionRevisionsTable> {
  $$SessionRevisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnOrderings(column));
}

class $$SessionRevisionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionRevisionsTable> {
  $$SessionRevisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get surahId =>
      $composableBuilder(column: $table.surahId, builder: (column) => column);

  GeneratedColumn<int> get fromAyah =>
      $composableBuilder(column: $table.fromAyah, builder: (column) => column);

  GeneratedColumn<int> get toAyah =>
      $composableBuilder(column: $table.toAyah, builder: (column) => column);
}

class $$SessionRevisionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionRevisionsTable,
    SessionRevision,
    $$SessionRevisionsTableFilterComposer,
    $$SessionRevisionsTableOrderingComposer,
    $$SessionRevisionsTableAnnotationComposer,
    $$SessionRevisionsTableCreateCompanionBuilder,
    $$SessionRevisionsTableUpdateCompanionBuilder,
    (
      SessionRevision,
      BaseReferences<_$AppDatabase, $SessionRevisionsTable, SessionRevision>
    ),
    SessionRevision,
    PrefetchHooks Function()> {
  $$SessionRevisionsTableTableManager(
      _$AppDatabase db, $SessionRevisionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionRevisionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionRevisionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionRevisionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> surahId = const Value.absent(),
            Value<int> fromAyah = const Value.absent(),
            Value<int> toAyah = const Value.absent(),
          }) =>
              SessionRevisionsCompanion(
            id: id,
            sessionId: sessionId,
            surahId: surahId,
            fromAyah: fromAyah,
            toAyah: toAyah,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int surahId,
            required int fromAyah,
            required int toAyah,
          }) =>
              SessionRevisionsCompanion.insert(
            id: id,
            sessionId: sessionId,
            surahId: surahId,
            fromAyah: fromAyah,
            toAyah: toAyah,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionRevisionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionRevisionsTable,
    SessionRevision,
    $$SessionRevisionsTableFilterComposer,
    $$SessionRevisionsTableOrderingComposer,
    $$SessionRevisionsTableAnnotationComposer,
    $$SessionRevisionsTableCreateCompanionBuilder,
    $$SessionRevisionsTableUpdateCompanionBuilder,
    (
      SessionRevision,
      BaseReferences<_$AppDatabase, $SessionRevisionsTable, SessionRevision>
    ),
    SessionRevision,
    PrefetchHooks Function()>;
typedef $$SessionEvaluationsTableCreateCompanionBuilder
    = SessionEvaluationsCompanion Function({
  Value<int> id,
  required int sessionId,
  Value<double> memorizationScore,
  Value<double> tajweedScore,
  Value<double> fluencyScore,
  Value<double> accuracyScore,
});
typedef $$SessionEvaluationsTableUpdateCompanionBuilder
    = SessionEvaluationsCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<double> memorizationScore,
  Value<double> tajweedScore,
  Value<double> fluencyScore,
  Value<double> accuracyScore,
});

class $$SessionEvaluationsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionEvaluationsTable> {
  $$SessionEvaluationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get memorizationScore => $composableBuilder(
      column: $table.memorizationScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tajweedScore => $composableBuilder(
      column: $table.tajweedScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fluencyScore => $composableBuilder(
      column: $table.fluencyScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracyScore => $composableBuilder(
      column: $table.accuracyScore, builder: (column) => ColumnFilters(column));
}

class $$SessionEvaluationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionEvaluationsTable> {
  $$SessionEvaluationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get memorizationScore => $composableBuilder(
      column: $table.memorizationScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tajweedScore => $composableBuilder(
      column: $table.tajweedScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fluencyScore => $composableBuilder(
      column: $table.fluencyScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracyScore => $composableBuilder(
      column: $table.accuracyScore,
      builder: (column) => ColumnOrderings(column));
}

class $$SessionEvaluationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionEvaluationsTable> {
  $$SessionEvaluationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<double> get memorizationScore => $composableBuilder(
      column: $table.memorizationScore, builder: (column) => column);

  GeneratedColumn<double> get tajweedScore => $composableBuilder(
      column: $table.tajweedScore, builder: (column) => column);

  GeneratedColumn<double> get fluencyScore => $composableBuilder(
      column: $table.fluencyScore, builder: (column) => column);

  GeneratedColumn<double> get accuracyScore => $composableBuilder(
      column: $table.accuracyScore, builder: (column) => column);
}

class $$SessionEvaluationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionEvaluationsTable,
    SessionEvaluation,
    $$SessionEvaluationsTableFilterComposer,
    $$SessionEvaluationsTableOrderingComposer,
    $$SessionEvaluationsTableAnnotationComposer,
    $$SessionEvaluationsTableCreateCompanionBuilder,
    $$SessionEvaluationsTableUpdateCompanionBuilder,
    (
      SessionEvaluation,
      BaseReferences<_$AppDatabase, $SessionEvaluationsTable, SessionEvaluation>
    ),
    SessionEvaluation,
    PrefetchHooks Function()> {
  $$SessionEvaluationsTableTableManager(
      _$AppDatabase db, $SessionEvaluationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionEvaluationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionEvaluationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionEvaluationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<double> memorizationScore = const Value.absent(),
            Value<double> tajweedScore = const Value.absent(),
            Value<double> fluencyScore = const Value.absent(),
            Value<double> accuracyScore = const Value.absent(),
          }) =>
              SessionEvaluationsCompanion(
            id: id,
            sessionId: sessionId,
            memorizationScore: memorizationScore,
            tajweedScore: tajweedScore,
            fluencyScore: fluencyScore,
            accuracyScore: accuracyScore,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            Value<double> memorizationScore = const Value.absent(),
            Value<double> tajweedScore = const Value.absent(),
            Value<double> fluencyScore = const Value.absent(),
            Value<double> accuracyScore = const Value.absent(),
          }) =>
              SessionEvaluationsCompanion.insert(
            id: id,
            sessionId: sessionId,
            memorizationScore: memorizationScore,
            tajweedScore: tajweedScore,
            fluencyScore: fluencyScore,
            accuracyScore: accuracyScore,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionEvaluationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionEvaluationsTable,
    SessionEvaluation,
    $$SessionEvaluationsTableFilterComposer,
    $$SessionEvaluationsTableOrderingComposer,
    $$SessionEvaluationsTableAnnotationComposer,
    $$SessionEvaluationsTableCreateCompanionBuilder,
    $$SessionEvaluationsTableUpdateCompanionBuilder,
    (
      SessionEvaluation,
      BaseReferences<_$AppDatabase, $SessionEvaluationsTable, SessionEvaluation>
    ),
    SessionEvaluation,
    PrefetchHooks Function()>;
typedef $$SchedulesTableCreateCompanionBuilder = SchedulesCompanion Function({
  Value<int> id,
  required int studentId,
  required DateTime date,
  required String time,
  Value<int?> memorizationSurahId,
  Value<int?> memorizationFromAyah,
  Value<int?> memorizationToAyah,
  Value<int?> revisionSurahId,
  Value<int?> revisionFromAyah,
  Value<int?> revisionToAyah,
  Value<bool> isCompleted,
  Value<DateTime> createdAt,
});
typedef $$SchedulesTableUpdateCompanionBuilder = SchedulesCompanion Function({
  Value<int> id,
  Value<int> studentId,
  Value<DateTime> date,
  Value<String> time,
  Value<int?> memorizationSurahId,
  Value<int?> memorizationFromAyah,
  Value<int?> memorizationToAyah,
  Value<int?> revisionSurahId,
  Value<int?> revisionFromAyah,
  Value<int?> revisionToAyah,
  Value<bool> isCompleted,
  Value<DateTime> createdAt,
});

class $$SchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memorizationSurahId => $composableBuilder(
      column: $table.memorizationSurahId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memorizationFromAyah => $composableBuilder(
      column: $table.memorizationFromAyah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memorizationToAyah => $composableBuilder(
      column: $table.memorizationToAyah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revisionSurahId => $composableBuilder(
      column: $table.revisionSurahId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revisionFromAyah => $composableBuilder(
      column: $table.revisionFromAyah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revisionToAyah => $composableBuilder(
      column: $table.revisionToAyah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memorizationSurahId => $composableBuilder(
      column: $table.memorizationSurahId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memorizationFromAyah => $composableBuilder(
      column: $table.memorizationFromAyah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memorizationToAyah => $composableBuilder(
      column: $table.memorizationToAyah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revisionSurahId => $composableBuilder(
      column: $table.revisionSurahId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revisionFromAyah => $composableBuilder(
      column: $table.revisionFromAyah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revisionToAyah => $composableBuilder(
      column: $table.revisionToAyah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get memorizationSurahId => $composableBuilder(
      column: $table.memorizationSurahId, builder: (column) => column);

  GeneratedColumn<int> get memorizationFromAyah => $composableBuilder(
      column: $table.memorizationFromAyah, builder: (column) => column);

  GeneratedColumn<int> get memorizationToAyah => $composableBuilder(
      column: $table.memorizationToAyah, builder: (column) => column);

  GeneratedColumn<int> get revisionSurahId => $composableBuilder(
      column: $table.revisionSurahId, builder: (column) => column);

  GeneratedColumn<int> get revisionFromAyah => $composableBuilder(
      column: $table.revisionFromAyah, builder: (column) => column);

  GeneratedColumn<int> get revisionToAyah => $composableBuilder(
      column: $table.revisionToAyah, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SchedulesTable,
    Schedule,
    $$SchedulesTableFilterComposer,
    $$SchedulesTableOrderingComposer,
    $$SchedulesTableAnnotationComposer,
    $$SchedulesTableCreateCompanionBuilder,
    $$SchedulesTableUpdateCompanionBuilder,
    (Schedule, BaseReferences<_$AppDatabase, $SchedulesTable, Schedule>),
    Schedule,
    PrefetchHooks Function()> {
  $$SchedulesTableTableManager(_$AppDatabase db, $SchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> time = const Value.absent(),
            Value<int?> memorizationSurahId = const Value.absent(),
            Value<int?> memorizationFromAyah = const Value.absent(),
            Value<int?> memorizationToAyah = const Value.absent(),
            Value<int?> revisionSurahId = const Value.absent(),
            Value<int?> revisionFromAyah = const Value.absent(),
            Value<int?> revisionToAyah = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SchedulesCompanion(
            id: id,
            studentId: studentId,
            date: date,
            time: time,
            memorizationSurahId: memorizationSurahId,
            memorizationFromAyah: memorizationFromAyah,
            memorizationToAyah: memorizationToAyah,
            revisionSurahId: revisionSurahId,
            revisionFromAyah: revisionFromAyah,
            revisionToAyah: revisionToAyah,
            isCompleted: isCompleted,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int studentId,
            required DateTime date,
            required String time,
            Value<int?> memorizationSurahId = const Value.absent(),
            Value<int?> memorizationFromAyah = const Value.absent(),
            Value<int?> memorizationToAyah = const Value.absent(),
            Value<int?> revisionSurahId = const Value.absent(),
            Value<int?> revisionFromAyah = const Value.absent(),
            Value<int?> revisionToAyah = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SchedulesCompanion.insert(
            id: id,
            studentId: studentId,
            date: date,
            time: time,
            memorizationSurahId: memorizationSurahId,
            memorizationFromAyah: memorizationFromAyah,
            memorizationToAyah: memorizationToAyah,
            revisionSurahId: revisionSurahId,
            revisionFromAyah: revisionFromAyah,
            revisionToAyah: revisionToAyah,
            isCompleted: isCompleted,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SchedulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SchedulesTable,
    Schedule,
    $$SchedulesTableFilterComposer,
    $$SchedulesTableOrderingComposer,
    $$SchedulesTableAnnotationComposer,
    $$SchedulesTableCreateCompanionBuilder,
    $$SchedulesTableUpdateCompanionBuilder,
    (Schedule, BaseReferences<_$AppDatabase, $SchedulesTable, Schedule>),
    Schedule,
    PrefetchHooks Function()>;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  required int studentId,
  required String title,
  Value<String> goalType,
  Value<int?> targetSurahId,
  Value<int?> targetJuzNumber,
  required DateTime startDate,
  Value<DateTime?> targetDate,
  Value<String> status,
  Value<DateTime> createdAt,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  Value<int> studentId,
  Value<String> title,
  Value<String> goalType,
  Value<int?> targetSurahId,
  Value<int?> targetJuzNumber,
  Value<DateTime> startDate,
  Value<DateTime?> targetDate,
  Value<String> status,
  Value<DateTime> createdAt,
});

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalType => $composableBuilder(
      column: $table.goalType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetSurahId => $composableBuilder(
      column: $table.targetSurahId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetJuzNumber => $composableBuilder(
      column: $table.targetJuzNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalType => $composableBuilder(
      column: $table.goalType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetSurahId => $composableBuilder(
      column: $table.targetSurahId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetJuzNumber => $composableBuilder(
      column: $table.targetJuzNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<int> get targetSurahId => $composableBuilder(
      column: $table.targetSurahId, builder: (column) => column);

  GeneratedColumn<int> get targetJuzNumber => $composableBuilder(
      column: $table.targetJuzNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
    Goal,
    PrefetchHooks Function()> {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> goalType = const Value.absent(),
            Value<int?> targetSurahId = const Value.absent(),
            Value<int?> targetJuzNumber = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> targetDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GoalsCompanion(
            id: id,
            studentId: studentId,
            title: title,
            goalType: goalType,
            targetSurahId: targetSurahId,
            targetJuzNumber: targetJuzNumber,
            startDate: startDate,
            targetDate: targetDate,
            status: status,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int studentId,
            required String title,
            Value<String> goalType = const Value.absent(),
            Value<int?> targetSurahId = const Value.absent(),
            Value<int?> targetJuzNumber = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> targetDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GoalsCompanion.insert(
            id: id,
            studentId: studentId,
            title: title,
            goalType: goalType,
            targetSurahId: targetSurahId,
            targetJuzNumber: targetJuzNumber,
            startDate: startDate,
            targetDate: targetDate,
            status: status,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
    Goal,
    PrefetchHooks Function()>;
typedef $$MemorizedRangesTableCreateCompanionBuilder = MemorizedRangesCompanion
    Function({
  Value<int> id,
  required int studentId,
  required int surahId,
  required int fromAyah,
  required int toAyah,
  Value<String> status,
  Value<int> revisionCycleDays,
  Value<DateTime?> lastRevisedAt,
  Value<DateTime?> nextReviewDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$MemorizedRangesTableUpdateCompanionBuilder = MemorizedRangesCompanion
    Function({
  Value<int> id,
  Value<int> studentId,
  Value<int> surahId,
  Value<int> fromAyah,
  Value<int> toAyah,
  Value<String> status,
  Value<int> revisionCycleDays,
  Value<DateTime?> lastRevisedAt,
  Value<DateTime?> nextReviewDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$MemorizedRangesTableFilterComposer
    extends Composer<_$AppDatabase, $MemorizedRangesTable> {
  $$MemorizedRangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revisionCycleDays => $composableBuilder(
      column: $table.revisionCycleDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastRevisedAt => $composableBuilder(
      column: $table.lastRevisedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReviewDate => $composableBuilder(
      column: $table.nextReviewDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MemorizedRangesTableOrderingComposer
    extends Composer<_$AppDatabase, $MemorizedRangesTable> {
  $$MemorizedRangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revisionCycleDays => $composableBuilder(
      column: $table.revisionCycleDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastRevisedAt => $composableBuilder(
      column: $table.lastRevisedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReviewDate => $composableBuilder(
      column: $table.nextReviewDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MemorizedRangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemorizedRangesTable> {
  $$MemorizedRangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<int> get surahId =>
      $composableBuilder(column: $table.surahId, builder: (column) => column);

  GeneratedColumn<int> get fromAyah =>
      $composableBuilder(column: $table.fromAyah, builder: (column) => column);

  GeneratedColumn<int> get toAyah =>
      $composableBuilder(column: $table.toAyah, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get revisionCycleDays => $composableBuilder(
      column: $table.revisionCycleDays, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRevisedAt => $composableBuilder(
      column: $table.lastRevisedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewDate => $composableBuilder(
      column: $table.nextReviewDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MemorizedRangesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MemorizedRangesTable,
    MemorizedRange,
    $$MemorizedRangesTableFilterComposer,
    $$MemorizedRangesTableOrderingComposer,
    $$MemorizedRangesTableAnnotationComposer,
    $$MemorizedRangesTableCreateCompanionBuilder,
    $$MemorizedRangesTableUpdateCompanionBuilder,
    (
      MemorizedRange,
      BaseReferences<_$AppDatabase, $MemorizedRangesTable, MemorizedRange>
    ),
    MemorizedRange,
    PrefetchHooks Function()> {
  $$MemorizedRangesTableTableManager(
      _$AppDatabase db, $MemorizedRangesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemorizedRangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemorizedRangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemorizedRangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<int> surahId = const Value.absent(),
            Value<int> fromAyah = const Value.absent(),
            Value<int> toAyah = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> revisionCycleDays = const Value.absent(),
            Value<DateTime?> lastRevisedAt = const Value.absent(),
            Value<DateTime?> nextReviewDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MemorizedRangesCompanion(
            id: id,
            studentId: studentId,
            surahId: surahId,
            fromAyah: fromAyah,
            toAyah: toAyah,
            status: status,
            revisionCycleDays: revisionCycleDays,
            lastRevisedAt: lastRevisedAt,
            nextReviewDate: nextReviewDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int studentId,
            required int surahId,
            required int fromAyah,
            required int toAyah,
            Value<String> status = const Value.absent(),
            Value<int> revisionCycleDays = const Value.absent(),
            Value<DateTime?> lastRevisedAt = const Value.absent(),
            Value<DateTime?> nextReviewDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MemorizedRangesCompanion.insert(
            id: id,
            studentId: studentId,
            surahId: surahId,
            fromAyah: fromAyah,
            toAyah: toAyah,
            status: status,
            revisionCycleDays: revisionCycleDays,
            lastRevisedAt: lastRevisedAt,
            nextReviewDate: nextReviewDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MemorizedRangesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MemorizedRangesTable,
    MemorizedRange,
    $$MemorizedRangesTableFilterComposer,
    $$MemorizedRangesTableOrderingComposer,
    $$MemorizedRangesTableAnnotationComposer,
    $$MemorizedRangesTableCreateCompanionBuilder,
    $$MemorizedRangesTableUpdateCompanionBuilder,
    (
      MemorizedRange,
      BaseReferences<_$AppDatabase, $MemorizedRangesTable, MemorizedRange>
    ),
    MemorizedRange,
    PrefetchHooks Function()>;
typedef $$PendingChangesTableCreateCompanionBuilder = PendingChangesCompanion
    Function({
  Value<int> id,
  required String entityType,
  required int entityLocalId,
  required String operation,
  required String payload,
  Value<DateTime> createdAt,
  Value<int> retryCount,
  Value<String?> lastError,
});
typedef $$PendingChangesTableUpdateCompanionBuilder = PendingChangesCompanion
    Function({
  Value<int> id,
  Value<String> entityType,
  Value<int> entityLocalId,
  Value<String> operation,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> retryCount,
  Value<String?> lastError,
});

class $$PendingChangesTableFilterComposer
    extends Composer<_$AppDatabase, $PendingChangesTable> {
  $$PendingChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entityLocalId => $composableBuilder(
      column: $table.entityLocalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));
}

class $$PendingChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingChangesTable> {
  $$PendingChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entityLocalId => $composableBuilder(
      column: $table.entityLocalId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));
}

class $$PendingChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingChangesTable> {
  $$PendingChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<int> get entityLocalId => $composableBuilder(
      column: $table.entityLocalId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$PendingChangesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PendingChangesTable,
    PendingChange,
    $$PendingChangesTableFilterComposer,
    $$PendingChangesTableOrderingComposer,
    $$PendingChangesTableAnnotationComposer,
    $$PendingChangesTableCreateCompanionBuilder,
    $$PendingChangesTableUpdateCompanionBuilder,
    (
      PendingChange,
      BaseReferences<_$AppDatabase, $PendingChangesTable, PendingChange>
    ),
    PendingChange,
    PrefetchHooks Function()> {
  $$PendingChangesTableTableManager(
      _$AppDatabase db, $PendingChangesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<int> entityLocalId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
          }) =>
              PendingChangesCompanion(
            id: id,
            entityType: entityType,
            entityLocalId: entityLocalId,
            operation: operation,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            lastError: lastError,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entityType,
            required int entityLocalId,
            required String operation,
            required String payload,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
          }) =>
              PendingChangesCompanion.insert(
            id: id,
            entityType: entityType,
            entityLocalId: entityLocalId,
            operation: operation,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            lastError: lastError,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendingChangesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PendingChangesTable,
    PendingChange,
    $$PendingChangesTableFilterComposer,
    $$PendingChangesTableOrderingComposer,
    $$PendingChangesTableAnnotationComposer,
    $$PendingChangesTableCreateCompanionBuilder,
    $$PendingChangesTableUpdateCompanionBuilder,
    (
      PendingChange,
      BaseReferences<_$AppDatabase, $PendingChangesTable, PendingChange>
    ),
    PendingChange,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$JuzSurahRangesTableTableManager get juzSurahRanges =>
      $$JuzSurahRangesTableTableManager(_db, _db.juzSurahRanges);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SessionMemorizationsTableTableManager get sessionMemorizations =>
      $$SessionMemorizationsTableTableManager(_db, _db.sessionMemorizations);
  $$SessionRevisionsTableTableManager get sessionRevisions =>
      $$SessionRevisionsTableTableManager(_db, _db.sessionRevisions);
  $$SessionEvaluationsTableTableManager get sessionEvaluations =>
      $$SessionEvaluationsTableTableManager(_db, _db.sessionEvaluations);
  $$SchedulesTableTableManager get schedules =>
      $$SchedulesTableTableManager(_db, _db.schedules);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$MemorizedRangesTableTableManager get memorizedRanges =>
      $$MemorizedRangesTableTableManager(_db, _db.memorizedRanges);
  $$PendingChangesTableTableManager get pendingChanges =>
      $$PendingChangesTableTableManager(_db, _db.pendingChanges);
}
