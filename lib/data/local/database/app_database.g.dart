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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
  static const VerificationMeta _lastCompletedSurahIdMeta =
      const VerificationMeta('lastCompletedSurahId');
  @override
  late final GeneratedColumn<int> lastCompletedSurahId = GeneratedColumn<int>(
      'last_completed_surah_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _teacherIdMeta =
      const VerificationMeta('teacherId');
  @override
  late final GeneratedColumn<int> teacherId = GeneratedColumn<int>(
      'teacher_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, teacherId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(_teacherIdMeta,
          teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta));
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
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      teacherId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}teacher_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final String name;
  final int? teacherId;
  final DateTime createdAt;
  const Group(
      {required this.id,
      required this.name,
      this.teacherId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || teacherId != null) {
      map['teacher_id'] = Variable<int>(teacherId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: Value(name),
      teacherId: teacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherId),
      createdAt: Value(createdAt),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      teacherId: serializer.fromJson<int?>(json['teacherId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'teacherId': serializer.toJson<int?>(teacherId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Group copyWith(
          {int? id,
          String? name,
          Value<int?> teacherId = const Value.absent(),
          DateTime? createdAt}) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        teacherId: teacherId.present ? teacherId.value : this.teacherId,
        createdAt: createdAt ?? this.createdAt,
      );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('teacherId: $teacherId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, teacherId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.teacherId == this.teacherId &&
          other.createdAt == this.createdAt);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> teacherId;
  final Value<DateTime> createdAt;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.teacherId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? teacherId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (teacherId != null) 'teacher_id': teacherId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GroupsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int?>? teacherId,
      Value<DateTime>? createdAt}) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      teacherId: teacherId ?? this.teacherId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<int>(teacherId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('teacherId: $teacherId, ')
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
      'student_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES students (id)'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _sessionTypeMeta =
      const VerificationMeta('sessionType');
  @override
  late final GeneratedColumn<String> sessionType = GeneratedColumn<String>(
      'session_type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('فردي'));
  static const VerificationMeta _occurrenceDateMeta =
      const VerificationMeta('occurrenceDate');
  @override
  late final GeneratedColumn<DateTime> occurrenceDate =
      GeneratedColumn<DateTime>('occurrence_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        groupId,
        sessionType,
        occurrenceDate,
        date,
        time,
        notes,
        createdAt
      ];
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
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('session_type')) {
      context.handle(
          _sessionTypeMeta,
          sessionType.isAcceptableOrUnknown(
              data['session_type']!, _sessionTypeMeta));
    }
    if (data.containsKey('occurrence_date')) {
      context.handle(
          _occurrenceDateMeta,
          occurrenceDate.isAcceptableOrUnknown(
              data['occurrence_date']!, _occurrenceDateMeta));
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
          .read(DriftSqlType.int, data['${effectivePrefix}student_id']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id']),
      sessionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_type'])!,
      occurrenceDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}occurrence_date']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
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

  /// nullable منذ v4 (Sprint 2): جلسة جماعية (sessionType == 'جماعي') لا
  /// طالب واحد لها — الطلاب المرتبطون بها عبر SessionAttendances بدل هذا
  /// العمود. لسه مطلوب فعلياً لكل الجلسات الفردية الحالية.
  final int? studentId;

  /// nullable — فقط للجلسات الجماعية (sessionType == 'جماعي'). Sprint 2.
  final int? groupId;

  /// 'فردي' أو 'جماعي' — راجع core/enums/session_type.dart. Sprint 2.
  final String sessionType;

  /// تاريخ المناسبة المنطقي حين تُنشأ الجلسة من حلقة متكرّرة
  /// (materialize-on-write، بند 2.7) — يفرّق بين تاريخ *إنشاء* الصف وتاريخ
  /// *المناسبة* نفسها لو اختلفا (تسجيل حضور متأخر ليوم سابق مثلاً).
  /// Sprint 2.
  final DateTime? occurrenceDate;
  final DateTime date;
  final String time;
  final String? notes;
  final DateTime createdAt;
  const Session(
      {required this.id,
      this.studentId,
      this.groupId,
      required this.sessionType,
      this.occurrenceDate,
      required this.date,
      required this.time,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || studentId != null) {
      map['student_id'] = Variable<int>(studentId);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    map['session_type'] = Variable<String>(sessionType);
    if (!nullToAbsent || occurrenceDate != null) {
      map['occurrence_date'] = Variable<DateTime>(occurrenceDate);
    }
    map['date'] = Variable<DateTime>(date);
    map['time'] = Variable<String>(time);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      studentId: studentId == null && nullToAbsent
          ? const Value.absent()
          : Value(studentId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      sessionType: Value(sessionType),
      occurrenceDate: occurrenceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(occurrenceDate),
      date: Value(date),
      time: Value(time),
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
      studentId: serializer.fromJson<int?>(json['studentId']),
      groupId: serializer.fromJson<int?>(json['groupId']),
      sessionType: serializer.fromJson<String>(json['sessionType']),
      occurrenceDate: serializer.fromJson<DateTime?>(json['occurrenceDate']),
      date: serializer.fromJson<DateTime>(json['date']),
      time: serializer.fromJson<String>(json['time']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int?>(studentId),
      'groupId': serializer.toJson<int?>(groupId),
      'sessionType': serializer.toJson<String>(sessionType),
      'occurrenceDate': serializer.toJson<DateTime?>(occurrenceDate),
      'date': serializer.toJson<DateTime>(date),
      'time': serializer.toJson<String>(time),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Session copyWith(
          {int? id,
          Value<int?> studentId = const Value.absent(),
          Value<int?> groupId = const Value.absent(),
          String? sessionType,
          Value<DateTime?> occurrenceDate = const Value.absent(),
          DateTime? date,
          String? time,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      Session(
        id: id ?? this.id,
        studentId: studentId.present ? studentId.value : this.studentId,
        groupId: groupId.present ? groupId.value : this.groupId,
        sessionType: sessionType ?? this.sessionType,
        occurrenceDate:
            occurrenceDate.present ? occurrenceDate.value : this.occurrenceDate,
        date: date ?? this.date,
        time: time ?? this.time,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      sessionType:
          data.sessionType.present ? data.sessionType.value : this.sessionType,
      occurrenceDate: data.occurrenceDate.present
          ? data.occurrenceDate.value
          : this.occurrenceDate,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('groupId: $groupId, ')
          ..write('sessionType: $sessionType, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, groupId, sessionType,
      occurrenceDate, date, time, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.groupId == this.groupId &&
          other.sessionType == this.sessionType &&
          other.occurrenceDate == this.occurrenceDate &&
          other.date == this.date &&
          other.time == this.time &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int?> studentId;
  final Value<int?> groupId;
  final Value<String> sessionType;
  final Value<DateTime?> occurrenceDate;
  final Value<DateTime> date;
  final Value<String> time;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sessionType = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sessionType = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    required DateTime date,
    required String time,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : date = Value(date),
        time = Value(time);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<int>? groupId,
    Expression<String>? sessionType,
    Expression<DateTime>? occurrenceDate,
    Expression<DateTime>? date,
    Expression<String>? time,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (groupId != null) 'group_id': groupId,
      if (sessionType != null) 'session_type': sessionType,
      if (occurrenceDate != null) 'occurrence_date': occurrenceDate,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? studentId,
      Value<int?>? groupId,
      Value<String>? sessionType,
      Value<DateTime?>? occurrenceDate,
      Value<DateTime>? date,
      Value<String>? time,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return SessionsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      groupId: groupId ?? this.groupId,
      sessionType: sessionType ?? this.sessionType,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      date: date ?? this.date,
      time: time ?? this.time,
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
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (sessionType.present) {
      map['session_type'] = Variable<String>(sessionType.value);
    }
    if (occurrenceDate.present) {
      map['occurrence_date'] = Variable<DateTime>(occurrenceDate.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
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
          ..write('groupId: $groupId, ')
          ..write('sessionType: $sessionType, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'UNIQUE REFERENCES sessions (id)'));
  static const VerificationMeta _surahIdMeta =
      const VerificationMeta('surahId');
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'UNIQUE REFERENCES sessions (id)'));
  static const VerificationMeta _surahIdMeta =
      const VerificationMeta('surahId');
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'UNIQUE REFERENCES sessions (id)'));
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

class $SessionAttendancesTable extends SessionAttendances
    with TableInfo<$SessionAttendancesTable, SessionAttendance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionAttendancesTable(this.attachedDatabase, [this._alias]);
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
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sessions (id)'));
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES students (id)'));
  static const VerificationMeta _attendanceStatusMeta =
      const VerificationMeta('attendanceStatus');
  @override
  late final GeneratedColumn<String> attendanceStatus = GeneratedColumn<String>(
      'attendance_status', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('حاضر'));
  static const VerificationMeta _memorizationSurahIdMeta =
      const VerificationMeta('memorizationSurahId');
  @override
  late final GeneratedColumn<int> memorizationSurahId = GeneratedColumn<int>(
      'memorization_surah_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recitationOutcomeMeta =
      const VerificationMeta('recitationOutcome');
  @override
  late final GeneratedColumn<String> recitationOutcome =
      GeneratedColumn<String>('recitation_outcome', aliasedName, true,
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
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        studentId,
        attendanceStatus,
        memorizationSurahId,
        memorizationFromAyah,
        memorizationToAyah,
        revisionSurahId,
        revisionFromAyah,
        revisionToAyah,
        memorizationScore,
        tajweedScore,
        fluencyScore,
        accuracyScore,
        notes,
        recitationOutcome,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_attendances';
  @override
  VerificationContext validateIntegrity(Insertable<SessionAttendance> instance,
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
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('attendance_status')) {
      context.handle(
          _attendanceStatusMeta,
          attendanceStatus.isAcceptableOrUnknown(
              data['attendance_status']!, _attendanceStatusMeta));
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
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('recitation_outcome')) {
      context.handle(
          _recitationOutcomeMeta,
          recitationOutcome.isAcceptableOrUnknown(
              data['recitation_outcome']!, _recitationOutcomeMeta));
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {sessionId, studentId},
      ];
  @override
  SessionAttendance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionAttendance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      attendanceStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}attendance_status'])!,
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
      memorizationScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}memorization_score'])!,
      tajweedScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tajweed_score'])!,
      fluencyScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fluency_score'])!,
      accuracyScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy_score'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      recitationOutcome: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recitation_outcome']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SessionAttendancesTable createAlias(String alias) {
    return $SessionAttendancesTable(attachedDatabase, alias);
  }
}

class SessionAttendance extends DataClass
    implements Insertable<SessionAttendance> {
  final int id;
  final int sessionId;
  final int studentId;
  final String attendanceStatus;
  final int? memorizationSurahId;
  final int? memorizationFromAyah;
  final int? memorizationToAyah;
  final int? revisionSurahId;
  final int? revisionFromAyah;
  final int? revisionToAyah;
  final double memorizationScore;
  final double tajweedScore;
  final double fluencyScore;
  final double accuracyScore;
  final String? notes;
  final String? recitationOutcome;
  final DateTime createdAt;
  const SessionAttendance(
      {required this.id,
      required this.sessionId,
      required this.studentId,
      required this.attendanceStatus,
      this.memorizationSurahId,
      this.memorizationFromAyah,
      this.memorizationToAyah,
      this.revisionSurahId,
      this.revisionFromAyah,
      this.revisionToAyah,
      required this.memorizationScore,
      required this.tajweedScore,
      required this.fluencyScore,
      required this.accuracyScore,
      this.notes,
      this.recitationOutcome,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['student_id'] = Variable<int>(studentId);
    map['attendance_status'] = Variable<String>(attendanceStatus);
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
    map['memorization_score'] = Variable<double>(memorizationScore);
    map['tajweed_score'] = Variable<double>(tajweedScore);
    map['fluency_score'] = Variable<double>(fluencyScore);
    map['accuracy_score'] = Variable<double>(accuracyScore);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || recitationOutcome != null) {
      map['recitation_outcome'] = Variable<String>(recitationOutcome);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionAttendancesCompanion toCompanion(bool nullToAbsent) {
    return SessionAttendancesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      studentId: Value(studentId),
      attendanceStatus: Value(attendanceStatus),
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
      memorizationScore: Value(memorizationScore),
      tajweedScore: Value(tajweedScore),
      fluencyScore: Value(fluencyScore),
      accuracyScore: Value(accuracyScore),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      recitationOutcome: recitationOutcome == null && nullToAbsent
          ? const Value.absent()
          : Value(recitationOutcome),
      createdAt: Value(createdAt),
    );
  }

  factory SessionAttendance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionAttendance(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      studentId: serializer.fromJson<int>(json['studentId']),
      attendanceStatus: serializer.fromJson<String>(json['attendanceStatus']),
      memorizationSurahId:
          serializer.fromJson<int?>(json['memorizationSurahId']),
      memorizationFromAyah:
          serializer.fromJson<int?>(json['memorizationFromAyah']),
      memorizationToAyah: serializer.fromJson<int?>(json['memorizationToAyah']),
      revisionSurahId: serializer.fromJson<int?>(json['revisionSurahId']),
      revisionFromAyah: serializer.fromJson<int?>(json['revisionFromAyah']),
      revisionToAyah: serializer.fromJson<int?>(json['revisionToAyah']),
      memorizationScore: serializer.fromJson<double>(json['memorizationScore']),
      tajweedScore: serializer.fromJson<double>(json['tajweedScore']),
      fluencyScore: serializer.fromJson<double>(json['fluencyScore']),
      accuracyScore: serializer.fromJson<double>(json['accuracyScore']),
      notes: serializer.fromJson<String?>(json['notes']),
      recitationOutcome:
          serializer.fromJson<String?>(json['recitationOutcome']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'studentId': serializer.toJson<int>(studentId),
      'attendanceStatus': serializer.toJson<String>(attendanceStatus),
      'memorizationSurahId': serializer.toJson<int?>(memorizationSurahId),
      'memorizationFromAyah': serializer.toJson<int?>(memorizationFromAyah),
      'memorizationToAyah': serializer.toJson<int?>(memorizationToAyah),
      'revisionSurahId': serializer.toJson<int?>(revisionSurahId),
      'revisionFromAyah': serializer.toJson<int?>(revisionFromAyah),
      'revisionToAyah': serializer.toJson<int?>(revisionToAyah),
      'memorizationScore': serializer.toJson<double>(memorizationScore),
      'tajweedScore': serializer.toJson<double>(tajweedScore),
      'fluencyScore': serializer.toJson<double>(fluencyScore),
      'accuracyScore': serializer.toJson<double>(accuracyScore),
      'notes': serializer.toJson<String?>(notes),
      'recitationOutcome': serializer.toJson<String?>(recitationOutcome),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SessionAttendance copyWith(
          {int? id,
          int? sessionId,
          int? studentId,
          String? attendanceStatus,
          Value<int?> memorizationSurahId = const Value.absent(),
          Value<int?> memorizationFromAyah = const Value.absent(),
          Value<int?> memorizationToAyah = const Value.absent(),
          Value<int?> revisionSurahId = const Value.absent(),
          Value<int?> revisionFromAyah = const Value.absent(),
          Value<int?> revisionToAyah = const Value.absent(),
          double? memorizationScore,
          double? tajweedScore,
          double? fluencyScore,
          double? accuracyScore,
          Value<String?> notes = const Value.absent(),
          Value<String?> recitationOutcome = const Value.absent(),
          DateTime? createdAt}) =>
      SessionAttendance(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        studentId: studentId ?? this.studentId,
        attendanceStatus: attendanceStatus ?? this.attendanceStatus,
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
        memorizationScore: memorizationScore ?? this.memorizationScore,
        tajweedScore: tajweedScore ?? this.tajweedScore,
        fluencyScore: fluencyScore ?? this.fluencyScore,
        accuracyScore: accuracyScore ?? this.accuracyScore,
        notes: notes.present ? notes.value : this.notes,
        recitationOutcome: recitationOutcome.present
            ? recitationOutcome.value
            : this.recitationOutcome,
        createdAt: createdAt ?? this.createdAt,
      );
  SessionAttendance copyWithCompanion(SessionAttendancesCompanion data) {
    return SessionAttendance(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      attendanceStatus: data.attendanceStatus.present
          ? data.attendanceStatus.value
          : this.attendanceStatus,
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
      notes: data.notes.present ? data.notes.value : this.notes,
      recitationOutcome: data.recitationOutcome.present
          ? data.recitationOutcome.value
          : this.recitationOutcome,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionAttendance(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('studentId: $studentId, ')
          ..write('attendanceStatus: $attendanceStatus, ')
          ..write('memorizationSurahId: $memorizationSurahId, ')
          ..write('memorizationFromAyah: $memorizationFromAyah, ')
          ..write('memorizationToAyah: $memorizationToAyah, ')
          ..write('revisionSurahId: $revisionSurahId, ')
          ..write('revisionFromAyah: $revisionFromAyah, ')
          ..write('revisionToAyah: $revisionToAyah, ')
          ..write('memorizationScore: $memorizationScore, ')
          ..write('tajweedScore: $tajweedScore, ')
          ..write('fluencyScore: $fluencyScore, ')
          ..write('accuracyScore: $accuracyScore, ')
          ..write('notes: $notes, ')
          ..write('recitationOutcome: $recitationOutcome, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sessionId,
      studentId,
      attendanceStatus,
      memorizationSurahId,
      memorizationFromAyah,
      memorizationToAyah,
      revisionSurahId,
      revisionFromAyah,
      revisionToAyah,
      memorizationScore,
      tajweedScore,
      fluencyScore,
      accuracyScore,
      notes,
      recitationOutcome,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionAttendance &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.studentId == this.studentId &&
          other.attendanceStatus == this.attendanceStatus &&
          other.memorizationSurahId == this.memorizationSurahId &&
          other.memorizationFromAyah == this.memorizationFromAyah &&
          other.memorizationToAyah == this.memorizationToAyah &&
          other.revisionSurahId == this.revisionSurahId &&
          other.revisionFromAyah == this.revisionFromAyah &&
          other.revisionToAyah == this.revisionToAyah &&
          other.memorizationScore == this.memorizationScore &&
          other.tajweedScore == this.tajweedScore &&
          other.fluencyScore == this.fluencyScore &&
          other.accuracyScore == this.accuracyScore &&
          other.notes == this.notes &&
          other.recitationOutcome == this.recitationOutcome &&
          other.createdAt == this.createdAt);
}

class SessionAttendancesCompanion extends UpdateCompanion<SessionAttendance> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> studentId;
  final Value<String> attendanceStatus;
  final Value<int?> memorizationSurahId;
  final Value<int?> memorizationFromAyah;
  final Value<int?> memorizationToAyah;
  final Value<int?> revisionSurahId;
  final Value<int?> revisionFromAyah;
  final Value<int?> revisionToAyah;
  final Value<double> memorizationScore;
  final Value<double> tajweedScore;
  final Value<double> fluencyScore;
  final Value<double> accuracyScore;
  final Value<String?> notes;
  final Value<String?> recitationOutcome;
  final Value<DateTime> createdAt;
  const SessionAttendancesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.attendanceStatus = const Value.absent(),
    this.memorizationSurahId = const Value.absent(),
    this.memorizationFromAyah = const Value.absent(),
    this.memorizationToAyah = const Value.absent(),
    this.revisionSurahId = const Value.absent(),
    this.revisionFromAyah = const Value.absent(),
    this.revisionToAyah = const Value.absent(),
    this.memorizationScore = const Value.absent(),
    this.tajweedScore = const Value.absent(),
    this.fluencyScore = const Value.absent(),
    this.accuracyScore = const Value.absent(),
    this.notes = const Value.absent(),
    this.recitationOutcome = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionAttendancesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int studentId,
    this.attendanceStatus = const Value.absent(),
    this.memorizationSurahId = const Value.absent(),
    this.memorizationFromAyah = const Value.absent(),
    this.memorizationToAyah = const Value.absent(),
    this.revisionSurahId = const Value.absent(),
    this.revisionFromAyah = const Value.absent(),
    this.revisionToAyah = const Value.absent(),
    this.memorizationScore = const Value.absent(),
    this.tajweedScore = const Value.absent(),
    this.fluencyScore = const Value.absent(),
    this.accuracyScore = const Value.absent(),
    this.notes = const Value.absent(),
    this.recitationOutcome = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : sessionId = Value(sessionId),
        studentId = Value(studentId);
  static Insertable<SessionAttendance> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? studentId,
    Expression<String>? attendanceStatus,
    Expression<int>? memorizationSurahId,
    Expression<int>? memorizationFromAyah,
    Expression<int>? memorizationToAyah,
    Expression<int>? revisionSurahId,
    Expression<int>? revisionFromAyah,
    Expression<int>? revisionToAyah,
    Expression<double>? memorizationScore,
    Expression<double>? tajweedScore,
    Expression<double>? fluencyScore,
    Expression<double>? accuracyScore,
    Expression<String>? notes,
    Expression<String>? recitationOutcome,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (studentId != null) 'student_id': studentId,
      if (attendanceStatus != null) 'attendance_status': attendanceStatus,
      if (memorizationSurahId != null)
        'memorization_surah_id': memorizationSurahId,
      if (memorizationFromAyah != null)
        'memorization_from_ayah': memorizationFromAyah,
      if (memorizationToAyah != null)
        'memorization_to_ayah': memorizationToAyah,
      if (revisionSurahId != null) 'revision_surah_id': revisionSurahId,
      if (revisionFromAyah != null) 'revision_from_ayah': revisionFromAyah,
      if (revisionToAyah != null) 'revision_to_ayah': revisionToAyah,
      if (memorizationScore != null) 'memorization_score': memorizationScore,
      if (tajweedScore != null) 'tajweed_score': tajweedScore,
      if (fluencyScore != null) 'fluency_score': fluencyScore,
      if (accuracyScore != null) 'accuracy_score': accuracyScore,
      if (notes != null) 'notes': notes,
      if (recitationOutcome != null) 'recitation_outcome': recitationOutcome,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionAttendancesCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? studentId,
      Value<String>? attendanceStatus,
      Value<int?>? memorizationSurahId,
      Value<int?>? memorizationFromAyah,
      Value<int?>? memorizationToAyah,
      Value<int?>? revisionSurahId,
      Value<int?>? revisionFromAyah,
      Value<int?>? revisionToAyah,
      Value<double>? memorizationScore,
      Value<double>? tajweedScore,
      Value<double>? fluencyScore,
      Value<double>? accuracyScore,
      Value<String?>? notes,
      Value<String?>? recitationOutcome,
      Value<DateTime>? createdAt}) {
    return SessionAttendancesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      studentId: studentId ?? this.studentId,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      memorizationSurahId: memorizationSurahId ?? this.memorizationSurahId,
      memorizationFromAyah: memorizationFromAyah ?? this.memorizationFromAyah,
      memorizationToAyah: memorizationToAyah ?? this.memorizationToAyah,
      revisionSurahId: revisionSurahId ?? this.revisionSurahId,
      revisionFromAyah: revisionFromAyah ?? this.revisionFromAyah,
      revisionToAyah: revisionToAyah ?? this.revisionToAyah,
      memorizationScore: memorizationScore ?? this.memorizationScore,
      tajweedScore: tajweedScore ?? this.tajweedScore,
      fluencyScore: fluencyScore ?? this.fluencyScore,
      accuracyScore: accuracyScore ?? this.accuracyScore,
      notes: notes ?? this.notes,
      recitationOutcome: recitationOutcome ?? this.recitationOutcome,
      createdAt: createdAt ?? this.createdAt,
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
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (attendanceStatus.present) {
      map['attendance_status'] = Variable<String>(attendanceStatus.value);
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
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (recitationOutcome.present) {
      map['recitation_outcome'] = Variable<String>(recitationOutcome.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionAttendancesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('studentId: $studentId, ')
          ..write('attendanceStatus: $attendanceStatus, ')
          ..write('memorizationSurahId: $memorizationSurahId, ')
          ..write('memorizationFromAyah: $memorizationFromAyah, ')
          ..write('memorizationToAyah: $memorizationToAyah, ')
          ..write('revisionSurahId: $revisionSurahId, ')
          ..write('revisionFromAyah: $revisionFromAyah, ')
          ..write('revisionToAyah: $revisionToAyah, ')
          ..write('memorizationScore: $memorizationScore, ')
          ..write('tajweedScore: $tajweedScore, ')
          ..write('fluencyScore: $fluencyScore, ')
          ..write('accuracyScore: $accuracyScore, ')
          ..write('notes: $notes, ')
          ..write('recitationOutcome: $recitationOutcome, ')
          ..write('createdAt: $createdAt')
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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES students (id)'));
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
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES students (id)'));
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
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES students (id)'));
  static const VerificationMeta _surahIdMeta =
      const VerificationMeta('surahId');
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES surahs (id)'));
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

class $GroupMembersTable extends GroupMembers
    with TableInfo<$GroupMembersTable, GroupMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES students (id)'));
  static const VerificationMeta _joinedAtMeta =
      const VerificationMeta('joinedAt');
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
      'joined_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, groupId, studentId, joinedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members';
  @override
  VerificationContext validateIntegrity(Insertable<GroupMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('joined_at')) {
      context.handle(_joinedAtMeta,
          joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {groupId, studentId},
      ];
  @override
  GroupMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      joinedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joined_at'])!,
    );
  }

  @override
  $GroupMembersTable createAlias(String alias) {
    return $GroupMembersTable(attachedDatabase, alias);
  }
}

class GroupMember extends DataClass implements Insertable<GroupMember> {
  final int id;
  final int groupId;
  final int studentId;
  final DateTime joinedAt;
  const GroupMember(
      {required this.id,
      required this.groupId,
      required this.studentId,
      required this.joinedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['student_id'] = Variable<int>(studentId);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    return map;
  }

  GroupMembersCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      studentId: Value(studentId),
      joinedAt: Value(joinedAt),
    );
  }

  factory GroupMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMember(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      studentId: serializer.fromJson<int>(json['studentId']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'studentId': serializer.toJson<int>(studentId),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
    };
  }

  GroupMember copyWith(
          {int? id, int? groupId, int? studentId, DateTime? joinedAt}) =>
      GroupMember(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        studentId: studentId ?? this.studentId,
        joinedAt: joinedAt ?? this.joinedAt,
      );
  GroupMember copyWithCompanion(GroupMembersCompanion data) {
    return GroupMember(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMember(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('studentId: $studentId, ')
          ..write('joinedAt: $joinedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, studentId, joinedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMember &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.studentId == this.studentId &&
          other.joinedAt == this.joinedAt);
}

class GroupMembersCompanion extends UpdateCompanion<GroupMember> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> studentId;
  final Value<DateTime> joinedAt;
  const GroupMembersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.joinedAt = const Value.absent(),
  });
  GroupMembersCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int studentId,
    this.joinedAt = const Value.absent(),
  })  : groupId = Value(groupId),
        studentId = Value(studentId);
  static Insertable<GroupMember> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? studentId,
    Expression<DateTime>? joinedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (studentId != null) 'student_id': studentId,
      if (joinedAt != null) 'joined_at': joinedAt,
    });
  }

  GroupMembersCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? studentId,
      Value<DateTime>? joinedAt}) {
    return GroupMembersCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      studentId: studentId ?? this.studentId,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('studentId: $studentId, ')
          ..write('joinedAt: $joinedAt')
          ..write(')'))
        .toString();
  }
}

class $GroupScheduleSlotsTable extends GroupScheduleSlots
    with TableInfo<$GroupScheduleSlotsTable, GroupScheduleSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupScheduleSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _weekdayMeta =
      const VerificationMeta('weekday');
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
      'weekday', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _anchorTypeMeta =
      const VerificationMeta('anchorType');
  @override
  late final GeneratedColumn<String> anchorType = GeneratedColumn<String>(
      'anchor_type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _fixedTimeMeta =
      const VerificationMeta('fixedTime');
  @override
  late final GeneratedColumn<String> fixedTime = GeneratedColumn<String>(
      'fixed_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _prayerNameMeta =
      const VerificationMeta('prayerName');
  @override
  late final GeneratedColumn<String> prayerName = GeneratedColumn<String>(
      'prayer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _offsetMinutesMeta =
      const VerificationMeta('offsetMinutes');
  @override
  late final GeneratedColumn<int> offsetMinutes = GeneratedColumn<int>(
      'offset_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _effectiveFromMeta =
      const VerificationMeta('effectiveFrom');
  @override
  late final GeneratedColumn<DateTime> effectiveFrom =
      GeneratedColumn<DateTime>('effective_from', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _effectiveToMeta =
      const VerificationMeta('effectiveTo');
  @override
  late final GeneratedColumn<DateTime> effectiveTo = GeneratedColumn<DateTime>(
      'effective_to', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
        groupId,
        weekday,
        anchorType,
        fixedTime,
        prayerName,
        offsetMinutes,
        effectiveFrom,
        effectiveTo,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_schedule_slots';
  @override
  VerificationContext validateIntegrity(Insertable<GroupScheduleSlot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(_weekdayMeta,
          weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta));
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('anchor_type')) {
      context.handle(
          _anchorTypeMeta,
          anchorType.isAcceptableOrUnknown(
              data['anchor_type']!, _anchorTypeMeta));
    } else if (isInserting) {
      context.missing(_anchorTypeMeta);
    }
    if (data.containsKey('fixed_time')) {
      context.handle(_fixedTimeMeta,
          fixedTime.isAcceptableOrUnknown(data['fixed_time']!, _fixedTimeMeta));
    }
    if (data.containsKey('prayer_name')) {
      context.handle(
          _prayerNameMeta,
          prayerName.isAcceptableOrUnknown(
              data['prayer_name']!, _prayerNameMeta));
    }
    if (data.containsKey('offset_minutes')) {
      context.handle(
          _offsetMinutesMeta,
          offsetMinutes.isAcceptableOrUnknown(
              data['offset_minutes']!, _offsetMinutesMeta));
    }
    if (data.containsKey('effective_from')) {
      context.handle(
          _effectiveFromMeta,
          effectiveFrom.isAcceptableOrUnknown(
              data['effective_from']!, _effectiveFromMeta));
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    if (data.containsKey('effective_to')) {
      context.handle(
          _effectiveToMeta,
          effectiveTo.isAcceptableOrUnknown(
              data['effective_to']!, _effectiveToMeta));
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
  GroupScheduleSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupScheduleSlot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      weekday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekday'])!,
      anchorType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}anchor_type'])!,
      fixedTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fixed_time']),
      prayerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prayer_name']),
      offsetMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}offset_minutes'])!,
      effectiveFrom: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}effective_from'])!,
      effectiveTo: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}effective_to']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GroupScheduleSlotsTable createAlias(String alias) {
    return $GroupScheduleSlotsTable(attachedDatabase, alias);
  }
}

class GroupScheduleSlot extends DataClass
    implements Insertable<GroupScheduleSlot> {
  final int id;
  final int groupId;

  /// ١ (الاثنين) إلى ٧ (الأحد) — مطابق لـ DateTime.weekday في Dart.
  final int weekday;

  /// 'وقت محدد' أو 'مرتبط بصلاة' — راجع core/enums/anchor_type.dart.
  final String anchorType;

  /// HH:mm — مطلوب فقط لو anchorType == 'وقت محدد'.
  final String? fixedTime;

  /// اسم الصلاة (مثال: 'المغرب') — مطلوب فقط لو anchorType == 'مرتبط بصلاة'.
  final String? prayerName;

  /// الإزاحة بالدقائق عن وقت الصلاة (يمكن أن تكون سالبة = قبل الصلاة).
  final int offsetMinutes;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final DateTime createdAt;
  const GroupScheduleSlot(
      {required this.id,
      required this.groupId,
      required this.weekday,
      required this.anchorType,
      this.fixedTime,
      this.prayerName,
      required this.offsetMinutes,
      required this.effectiveFrom,
      this.effectiveTo,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['weekday'] = Variable<int>(weekday);
    map['anchor_type'] = Variable<String>(anchorType);
    if (!nullToAbsent || fixedTime != null) {
      map['fixed_time'] = Variable<String>(fixedTime);
    }
    if (!nullToAbsent || prayerName != null) {
      map['prayer_name'] = Variable<String>(prayerName);
    }
    map['offset_minutes'] = Variable<int>(offsetMinutes);
    map['effective_from'] = Variable<DateTime>(effectiveFrom);
    if (!nullToAbsent || effectiveTo != null) {
      map['effective_to'] = Variable<DateTime>(effectiveTo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GroupScheduleSlotsCompanion toCompanion(bool nullToAbsent) {
    return GroupScheduleSlotsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      weekday: Value(weekday),
      anchorType: Value(anchorType),
      fixedTime: fixedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(fixedTime),
      prayerName: prayerName == null && nullToAbsent
          ? const Value.absent()
          : Value(prayerName),
      offsetMinutes: Value(offsetMinutes),
      effectiveFrom: Value(effectiveFrom),
      effectiveTo: effectiveTo == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveTo),
      createdAt: Value(createdAt),
    );
  }

  factory GroupScheduleSlot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupScheduleSlot(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      anchorType: serializer.fromJson<String>(json['anchorType']),
      fixedTime: serializer.fromJson<String?>(json['fixedTime']),
      prayerName: serializer.fromJson<String?>(json['prayerName']),
      offsetMinutes: serializer.fromJson<int>(json['offsetMinutes']),
      effectiveFrom: serializer.fromJson<DateTime>(json['effectiveFrom']),
      effectiveTo: serializer.fromJson<DateTime?>(json['effectiveTo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'weekday': serializer.toJson<int>(weekday),
      'anchorType': serializer.toJson<String>(anchorType),
      'fixedTime': serializer.toJson<String?>(fixedTime),
      'prayerName': serializer.toJson<String?>(prayerName),
      'offsetMinutes': serializer.toJson<int>(offsetMinutes),
      'effectiveFrom': serializer.toJson<DateTime>(effectiveFrom),
      'effectiveTo': serializer.toJson<DateTime?>(effectiveTo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GroupScheduleSlot copyWith(
          {int? id,
          int? groupId,
          int? weekday,
          String? anchorType,
          Value<String?> fixedTime = const Value.absent(),
          Value<String?> prayerName = const Value.absent(),
          int? offsetMinutes,
          DateTime? effectiveFrom,
          Value<DateTime?> effectiveTo = const Value.absent(),
          DateTime? createdAt}) =>
      GroupScheduleSlot(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        weekday: weekday ?? this.weekday,
        anchorType: anchorType ?? this.anchorType,
        fixedTime: fixedTime.present ? fixedTime.value : this.fixedTime,
        prayerName: prayerName.present ? prayerName.value : this.prayerName,
        offsetMinutes: offsetMinutes ?? this.offsetMinutes,
        effectiveFrom: effectiveFrom ?? this.effectiveFrom,
        effectiveTo: effectiveTo.present ? effectiveTo.value : this.effectiveTo,
        createdAt: createdAt ?? this.createdAt,
      );
  GroupScheduleSlot copyWithCompanion(GroupScheduleSlotsCompanion data) {
    return GroupScheduleSlot(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      anchorType:
          data.anchorType.present ? data.anchorType.value : this.anchorType,
      fixedTime: data.fixedTime.present ? data.fixedTime.value : this.fixedTime,
      prayerName:
          data.prayerName.present ? data.prayerName.value : this.prayerName,
      offsetMinutes: data.offsetMinutes.present
          ? data.offsetMinutes.value
          : this.offsetMinutes,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
      effectiveTo:
          data.effectiveTo.present ? data.effectiveTo.value : this.effectiveTo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupScheduleSlot(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('weekday: $weekday, ')
          ..write('anchorType: $anchorType, ')
          ..write('fixedTime: $fixedTime, ')
          ..write('prayerName: $prayerName, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, weekday, anchorType, fixedTime,
      prayerName, offsetMinutes, effectiveFrom, effectiveTo, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupScheduleSlot &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.weekday == this.weekday &&
          other.anchorType == this.anchorType &&
          other.fixedTime == this.fixedTime &&
          other.prayerName == this.prayerName &&
          other.offsetMinutes == this.offsetMinutes &&
          other.effectiveFrom == this.effectiveFrom &&
          other.effectiveTo == this.effectiveTo &&
          other.createdAt == this.createdAt);
}

class GroupScheduleSlotsCompanion extends UpdateCompanion<GroupScheduleSlot> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> weekday;
  final Value<String> anchorType;
  final Value<String?> fixedTime;
  final Value<String?> prayerName;
  final Value<int> offsetMinutes;
  final Value<DateTime> effectiveFrom;
  final Value<DateTime?> effectiveTo;
  final Value<DateTime> createdAt;
  const GroupScheduleSlotsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.anchorType = const Value.absent(),
    this.fixedTime = const Value.absent(),
    this.prayerName = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.effectiveTo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GroupScheduleSlotsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int weekday,
    required String anchorType,
    this.fixedTime = const Value.absent(),
    this.prayerName = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    required DateTime effectiveFrom,
    this.effectiveTo = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : groupId = Value(groupId),
        weekday = Value(weekday),
        anchorType = Value(anchorType),
        effectiveFrom = Value(effectiveFrom);
  static Insertable<GroupScheduleSlot> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? weekday,
    Expression<String>? anchorType,
    Expression<String>? fixedTime,
    Expression<String>? prayerName,
    Expression<int>? offsetMinutes,
    Expression<DateTime>? effectiveFrom,
    Expression<DateTime>? effectiveTo,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (weekday != null) 'weekday': weekday,
      if (anchorType != null) 'anchor_type': anchorType,
      if (fixedTime != null) 'fixed_time': fixedTime,
      if (prayerName != null) 'prayer_name': prayerName,
      if (offsetMinutes != null) 'offset_minutes': offsetMinutes,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (effectiveTo != null) 'effective_to': effectiveTo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GroupScheduleSlotsCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? weekday,
      Value<String>? anchorType,
      Value<String?>? fixedTime,
      Value<String?>? prayerName,
      Value<int>? offsetMinutes,
      Value<DateTime>? effectiveFrom,
      Value<DateTime?>? effectiveTo,
      Value<DateTime>? createdAt}) {
    return GroupScheduleSlotsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      weekday: weekday ?? this.weekday,
      anchorType: anchorType ?? this.anchorType,
      fixedTime: fixedTime ?? this.fixedTime,
      prayerName: prayerName ?? this.prayerName,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (anchorType.present) {
      map['anchor_type'] = Variable<String>(anchorType.value);
    }
    if (fixedTime.present) {
      map['fixed_time'] = Variable<String>(fixedTime.value);
    }
    if (prayerName.present) {
      map['prayer_name'] = Variable<String>(prayerName.value);
    }
    if (offsetMinutes.present) {
      map['offset_minutes'] = Variable<int>(offsetMinutes.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<DateTime>(effectiveFrom.value);
    }
    if (effectiveTo.present) {
      map['effective_to'] = Variable<DateTime>(effectiveTo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupScheduleSlotsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('weekday: $weekday, ')
          ..write('anchorType: $anchorType, ')
          ..write('fixedTime: $fixedTime, ')
          ..write('prayerName: $prayerName, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ScheduleExceptionsTable extends ScheduleExceptions
    with TableInfo<$ScheduleExceptionsTable, ScheduleException> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleExceptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupScheduleSlotIdMeta =
      const VerificationMeta('groupScheduleSlotId');
  @override
  late final GeneratedColumn<int> groupScheduleSlotId = GeneratedColumn<int>(
      'group_schedule_slot_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES group_schedule_slots (id)'));
  static const VerificationMeta _occurrenceDateMeta =
      const VerificationMeta('occurrenceDate');
  @override
  late final GeneratedColumn<DateTime> occurrenceDate =
      GeneratedColumn<DateTime>('occurrence_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _exceptionTypeMeta =
      const VerificationMeta('exceptionType');
  @override
  late final GeneratedColumn<String> exceptionType = GeneratedColumn<String>(
      'exception_type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _newDateMeta =
      const VerificationMeta('newDate');
  @override
  late final GeneratedColumn<DateTime> newDate = GeneratedColumn<DateTime>(
      'new_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _newTimeMeta =
      const VerificationMeta('newTime');
  @override
  late final GeneratedColumn<String> newTime = GeneratedColumn<String>(
      'new_time', aliasedName, true,
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
  List<GeneratedColumn> get $columns => [
        id,
        groupScheduleSlotId,
        occurrenceDate,
        exceptionType,
        newDate,
        newTime,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_exceptions';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduleException> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_schedule_slot_id')) {
      context.handle(
          _groupScheduleSlotIdMeta,
          groupScheduleSlotId.isAcceptableOrUnknown(
              data['group_schedule_slot_id']!, _groupScheduleSlotIdMeta));
    } else if (isInserting) {
      context.missing(_groupScheduleSlotIdMeta);
    }
    if (data.containsKey('occurrence_date')) {
      context.handle(
          _occurrenceDateMeta,
          occurrenceDate.isAcceptableOrUnknown(
              data['occurrence_date']!, _occurrenceDateMeta));
    } else if (isInserting) {
      context.missing(_occurrenceDateMeta);
    }
    if (data.containsKey('exception_type')) {
      context.handle(
          _exceptionTypeMeta,
          exceptionType.isAcceptableOrUnknown(
              data['exception_type']!, _exceptionTypeMeta));
    } else if (isInserting) {
      context.missing(_exceptionTypeMeta);
    }
    if (data.containsKey('new_date')) {
      context.handle(_newDateMeta,
          newDate.isAcceptableOrUnknown(data['new_date']!, _newDateMeta));
    }
    if (data.containsKey('new_time')) {
      context.handle(_newTimeMeta,
          newTime.isAcceptableOrUnknown(data['new_time']!, _newTimeMeta));
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
  ScheduleException map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleException(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupScheduleSlotId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}group_schedule_slot_id'])!,
      occurrenceDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}occurrence_date'])!,
      exceptionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exception_type'])!,
      newDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}new_date']),
      newTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}new_time']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ScheduleExceptionsTable createAlias(String alias) {
    return $ScheduleExceptionsTable(attachedDatabase, alias);
  }
}

class ScheduleException extends DataClass
    implements Insertable<ScheduleException> {
  final int id;
  final int groupScheduleSlotId;

  /// التاريخ الأصلي للمناسبة المُستثناة (قبل أي إعادة جدولة).
  final DateTime occurrenceDate;

  /// 'إلغاء' أو 'إعادة جدولة' — راجع core/enums/schedule_exception_type.dart.
  final String exceptionType;

  /// مطلوبان فقط لو exceptionType == 'إعادة جدولة'.
  final DateTime? newDate;
  final String? newTime;
  final DateTime createdAt;
  const ScheduleException(
      {required this.id,
      required this.groupScheduleSlotId,
      required this.occurrenceDate,
      required this.exceptionType,
      this.newDate,
      this.newTime,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_schedule_slot_id'] = Variable<int>(groupScheduleSlotId);
    map['occurrence_date'] = Variable<DateTime>(occurrenceDate);
    map['exception_type'] = Variable<String>(exceptionType);
    if (!nullToAbsent || newDate != null) {
      map['new_date'] = Variable<DateTime>(newDate);
    }
    if (!nullToAbsent || newTime != null) {
      map['new_time'] = Variable<String>(newTime);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScheduleExceptionsCompanion toCompanion(bool nullToAbsent) {
    return ScheduleExceptionsCompanion(
      id: Value(id),
      groupScheduleSlotId: Value(groupScheduleSlotId),
      occurrenceDate: Value(occurrenceDate),
      exceptionType: Value(exceptionType),
      newDate: newDate == null && nullToAbsent
          ? const Value.absent()
          : Value(newDate),
      newTime: newTime == null && nullToAbsent
          ? const Value.absent()
          : Value(newTime),
      createdAt: Value(createdAt),
    );
  }

  factory ScheduleException.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleException(
      id: serializer.fromJson<int>(json['id']),
      groupScheduleSlotId:
          serializer.fromJson<int>(json['groupScheduleSlotId']),
      occurrenceDate: serializer.fromJson<DateTime>(json['occurrenceDate']),
      exceptionType: serializer.fromJson<String>(json['exceptionType']),
      newDate: serializer.fromJson<DateTime?>(json['newDate']),
      newTime: serializer.fromJson<String?>(json['newTime']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupScheduleSlotId': serializer.toJson<int>(groupScheduleSlotId),
      'occurrenceDate': serializer.toJson<DateTime>(occurrenceDate),
      'exceptionType': serializer.toJson<String>(exceptionType),
      'newDate': serializer.toJson<DateTime?>(newDate),
      'newTime': serializer.toJson<String?>(newTime),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScheduleException copyWith(
          {int? id,
          int? groupScheduleSlotId,
          DateTime? occurrenceDate,
          String? exceptionType,
          Value<DateTime?> newDate = const Value.absent(),
          Value<String?> newTime = const Value.absent(),
          DateTime? createdAt}) =>
      ScheduleException(
        id: id ?? this.id,
        groupScheduleSlotId: groupScheduleSlotId ?? this.groupScheduleSlotId,
        occurrenceDate: occurrenceDate ?? this.occurrenceDate,
        exceptionType: exceptionType ?? this.exceptionType,
        newDate: newDate.present ? newDate.value : this.newDate,
        newTime: newTime.present ? newTime.value : this.newTime,
        createdAt: createdAt ?? this.createdAt,
      );
  ScheduleException copyWithCompanion(ScheduleExceptionsCompanion data) {
    return ScheduleException(
      id: data.id.present ? data.id.value : this.id,
      groupScheduleSlotId: data.groupScheduleSlotId.present
          ? data.groupScheduleSlotId.value
          : this.groupScheduleSlotId,
      occurrenceDate: data.occurrenceDate.present
          ? data.occurrenceDate.value
          : this.occurrenceDate,
      exceptionType: data.exceptionType.present
          ? data.exceptionType.value
          : this.exceptionType,
      newDate: data.newDate.present ? data.newDate.value : this.newDate,
      newTime: data.newTime.present ? data.newTime.value : this.newTime,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleException(')
          ..write('id: $id, ')
          ..write('groupScheduleSlotId: $groupScheduleSlotId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('exceptionType: $exceptionType, ')
          ..write('newDate: $newDate, ')
          ..write('newTime: $newTime, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupScheduleSlotId, occurrenceDate,
      exceptionType, newDate, newTime, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleException &&
          other.id == this.id &&
          other.groupScheduleSlotId == this.groupScheduleSlotId &&
          other.occurrenceDate == this.occurrenceDate &&
          other.exceptionType == this.exceptionType &&
          other.newDate == this.newDate &&
          other.newTime == this.newTime &&
          other.createdAt == this.createdAt);
}

class ScheduleExceptionsCompanion extends UpdateCompanion<ScheduleException> {
  final Value<int> id;
  final Value<int> groupScheduleSlotId;
  final Value<DateTime> occurrenceDate;
  final Value<String> exceptionType;
  final Value<DateTime?> newDate;
  final Value<String?> newTime;
  final Value<DateTime> createdAt;
  const ScheduleExceptionsCompanion({
    this.id = const Value.absent(),
    this.groupScheduleSlotId = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    this.exceptionType = const Value.absent(),
    this.newDate = const Value.absent(),
    this.newTime = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ScheduleExceptionsCompanion.insert({
    this.id = const Value.absent(),
    required int groupScheduleSlotId,
    required DateTime occurrenceDate,
    required String exceptionType,
    this.newDate = const Value.absent(),
    this.newTime = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : groupScheduleSlotId = Value(groupScheduleSlotId),
        occurrenceDate = Value(occurrenceDate),
        exceptionType = Value(exceptionType);
  static Insertable<ScheduleException> custom({
    Expression<int>? id,
    Expression<int>? groupScheduleSlotId,
    Expression<DateTime>? occurrenceDate,
    Expression<String>? exceptionType,
    Expression<DateTime>? newDate,
    Expression<String>? newTime,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupScheduleSlotId != null)
        'group_schedule_slot_id': groupScheduleSlotId,
      if (occurrenceDate != null) 'occurrence_date': occurrenceDate,
      if (exceptionType != null) 'exception_type': exceptionType,
      if (newDate != null) 'new_date': newDate,
      if (newTime != null) 'new_time': newTime,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ScheduleExceptionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupScheduleSlotId,
      Value<DateTime>? occurrenceDate,
      Value<String>? exceptionType,
      Value<DateTime?>? newDate,
      Value<String?>? newTime,
      Value<DateTime>? createdAt}) {
    return ScheduleExceptionsCompanion(
      id: id ?? this.id,
      groupScheduleSlotId: groupScheduleSlotId ?? this.groupScheduleSlotId,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      exceptionType: exceptionType ?? this.exceptionType,
      newDate: newDate ?? this.newDate,
      newTime: newTime ?? this.newTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupScheduleSlotId.present) {
      map['group_schedule_slot_id'] = Variable<int>(groupScheduleSlotId.value);
    }
    if (occurrenceDate.present) {
      map['occurrence_date'] = Variable<DateTime>(occurrenceDate.value);
    }
    if (exceptionType.present) {
      map['exception_type'] = Variable<String>(exceptionType.value);
    }
    if (newDate.present) {
      map['new_date'] = Variable<DateTime>(newDate.value);
    }
    if (newTime.present) {
      map['new_time'] = Variable<String>(newTime.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleExceptionsCompanion(')
          ..write('id: $id, ')
          ..write('groupScheduleSlotId: $groupScheduleSlotId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('exceptionType: $exceptionType, ')
          ..write('newDate: $newDate, ')
          ..write('newTime: $newTime, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $JuzQuarterProgressTable extends JuzQuarterProgress
    with TableInfo<$JuzQuarterProgressTable, JuzQuarterProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JuzQuarterProgressTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES students (id)'));
  static const VerificationMeta _juzNumberMeta =
      const VerificationMeta('juzNumber');
  @override
  late final GeneratedColumn<int> juzNumber = GeneratedColumn<int>(
      'juz_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quarterIndexMeta =
      const VerificationMeta('quarterIndex');
  @override
  late final GeneratedColumn<int> quarterIndex = GeneratedColumn<int>(
      'quarter_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, studentId, juzNumber, quarterIndex, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'juz_quarter_progress';
  @override
  VerificationContext validateIntegrity(
      Insertable<JuzQuarterProgressData> instance,
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
    if (data.containsKey('juz_number')) {
      context.handle(_juzNumberMeta,
          juzNumber.isAcceptableOrUnknown(data['juz_number']!, _juzNumberMeta));
    } else if (isInserting) {
      context.missing(_juzNumberMeta);
    }
    if (data.containsKey('quarter_index')) {
      context.handle(
          _quarterIndexMeta,
          quarterIndex.isAcceptableOrUnknown(
              data['quarter_index']!, _quarterIndexMeta));
    } else if (isInserting) {
      context.missing(_quarterIndexMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {studentId, juzNumber, quarterIndex},
      ];
  @override
  JuzQuarterProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JuzQuarterProgressData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      juzNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}juz_number'])!,
      quarterIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quarter_index'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $JuzQuarterProgressTable createAlias(String alias) {
    return $JuzQuarterProgressTable(attachedDatabase, alias);
  }
}

class JuzQuarterProgressData extends DataClass
    implements Insertable<JuzQuarterProgressData> {
  final int id;
  final int studentId;
  final int juzNumber;
  final int quarterIndex;
  final DateTime completedAt;
  const JuzQuarterProgressData(
      {required this.id,
      required this.studentId,
      required this.juzNumber,
      required this.quarterIndex,
      required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['juz_number'] = Variable<int>(juzNumber);
    map['quarter_index'] = Variable<int>(quarterIndex);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  JuzQuarterProgressCompanion toCompanion(bool nullToAbsent) {
    return JuzQuarterProgressCompanion(
      id: Value(id),
      studentId: Value(studentId),
      juzNumber: Value(juzNumber),
      quarterIndex: Value(quarterIndex),
      completedAt: Value(completedAt),
    );
  }

  factory JuzQuarterProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JuzQuarterProgressData(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      juzNumber: serializer.fromJson<int>(json['juzNumber']),
      quarterIndex: serializer.fromJson<int>(json['quarterIndex']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'juzNumber': serializer.toJson<int>(juzNumber),
      'quarterIndex': serializer.toJson<int>(quarterIndex),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  JuzQuarterProgressData copyWith(
          {int? id,
          int? studentId,
          int? juzNumber,
          int? quarterIndex,
          DateTime? completedAt}) =>
      JuzQuarterProgressData(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        juzNumber: juzNumber ?? this.juzNumber,
        quarterIndex: quarterIndex ?? this.quarterIndex,
        completedAt: completedAt ?? this.completedAt,
      );
  JuzQuarterProgressData copyWithCompanion(JuzQuarterProgressCompanion data) {
    return JuzQuarterProgressData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      juzNumber: data.juzNumber.present ? data.juzNumber.value : this.juzNumber,
      quarterIndex: data.quarterIndex.present
          ? data.quarterIndex.value
          : this.quarterIndex,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JuzQuarterProgressData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('quarterIndex: $quarterIndex, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, juzNumber, quarterIndex, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JuzQuarterProgressData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.juzNumber == this.juzNumber &&
          other.quarterIndex == this.quarterIndex &&
          other.completedAt == this.completedAt);
}

class JuzQuarterProgressCompanion
    extends UpdateCompanion<JuzQuarterProgressData> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<int> juzNumber;
  final Value<int> quarterIndex;
  final Value<DateTime> completedAt;
  const JuzQuarterProgressCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.juzNumber = const Value.absent(),
    this.quarterIndex = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  JuzQuarterProgressCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required int juzNumber,
    required int quarterIndex,
    this.completedAt = const Value.absent(),
  })  : studentId = Value(studentId),
        juzNumber = Value(juzNumber),
        quarterIndex = Value(quarterIndex);
  static Insertable<JuzQuarterProgressData> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<int>? juzNumber,
    Expression<int>? quarterIndex,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (juzNumber != null) 'juz_number': juzNumber,
      if (quarterIndex != null) 'quarter_index': quarterIndex,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  JuzQuarterProgressCompanion copyWith(
      {Value<int>? id,
      Value<int>? studentId,
      Value<int>? juzNumber,
      Value<int>? quarterIndex,
      Value<DateTime>? completedAt}) {
    return JuzQuarterProgressCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      juzNumber: juzNumber ?? this.juzNumber,
      quarterIndex: quarterIndex ?? this.quarterIndex,
      completedAt: completedAt ?? this.completedAt,
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
    if (juzNumber.present) {
      map['juz_number'] = Variable<int>(juzNumber.value);
    }
    if (quarterIndex.present) {
      map['quarter_index'] = Variable<int>(quarterIndex.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JuzQuarterProgressCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('quarterIndex: $quarterIndex, ')
          ..write('completedAt: $completedAt')
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
  late final $GroupsTable groups = $GroupsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SessionMemorizationsTable sessionMemorizations =
      $SessionMemorizationsTable(this);
  late final $SessionRevisionsTable sessionRevisions =
      $SessionRevisionsTable(this);
  late final $SessionEvaluationsTable sessionEvaluations =
      $SessionEvaluationsTable(this);
  late final $SessionAttendancesTable sessionAttendances =
      $SessionAttendancesTable(this);
  late final $SchedulesTable schedules = $SchedulesTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $MemorizedRangesTable memorizedRanges =
      $MemorizedRangesTable(this);
  late final $GroupMembersTable groupMembers = $GroupMembersTable(this);
  late final $GroupScheduleSlotsTable groupScheduleSlots =
      $GroupScheduleSlotsTable(this);
  late final $ScheduleExceptionsTable scheduleExceptions =
      $ScheduleExceptionsTable(this);
  late final $JuzQuarterProgressTable juzQuarterProgress =
      $JuzQuarterProgressTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        surahs,
        juzSurahRanges,
        students,
        groups,
        sessions,
        sessionMemorizations,
        sessionRevisions,
        sessionEvaluations,
        sessionAttendances,
        schedules,
        goals,
        memorizedRanges,
        groupMembers,
        groupScheduleSlots,
        scheduleExceptions,
        juzQuarterProgress
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

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupsTable, List<Group>> _groupsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.groups,
          aliasName: 'users__id__groups__teacher_id');

  $$GroupsTableProcessedTableManager get groupsRefs {
    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.teacherId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

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

  Expression<bool> groupsRefs(
      Expression<bool> Function($$GroupsTableFilterComposer f) f) {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.teacherId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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

  Expression<T> groupsRefs<T extends Object>(
      Expression<T> Function($$GroupsTableAnnotationComposer a) f) {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.teacherId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool groupsRefs})> {
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
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({groupsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (groupsRefs) db.groups],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (groupsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Group>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._groupsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).groupsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.teacherId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
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
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool groupsRefs})>;
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

final class $$SurahsTableReferences
    extends BaseReferences<_$AppDatabase, $SurahsTable, Surah> {
  $$SurahsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JuzSurahRangesTable, List<JuzSurahRange>>
      _juzSurahRangesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.juzSurahRanges,
              aliasName: 'surahs__id__juz_surah_ranges__surah_id');

  $$JuzSurahRangesTableProcessedTableManager get juzSurahRangesRefs {
    final manager = $$JuzSurahRangesTableTableManager($_db, $_db.juzSurahRanges)
        .filter((f) => f.surahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_juzSurahRangesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessionMemorizationsTable,
      List<SessionMemorization>> _sessionMemorizationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sessionMemorizations,
          aliasName: 'surahs__id__session_memorizations__surah_id');

  $$SessionMemorizationsTableProcessedTableManager
      get sessionMemorizationsRefs {
    final manager =
        $$SessionMemorizationsTableTableManager($_db, $_db.sessionMemorizations)
            .filter((f) => f.surahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sessionMemorizationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessionRevisionsTable, List<SessionRevision>>
      _sessionRevisionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionRevisions,
              aliasName: 'surahs__id__session_revisions__surah_id');

  $$SessionRevisionsTableProcessedTableManager get sessionRevisionsRefs {
    final manager =
        $$SessionRevisionsTableTableManager($_db, $_db.sessionRevisions)
            .filter((f) => f.surahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sessionRevisionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GoalsTable, List<Goal>> _goalsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.goals,
          aliasName: 'surahs__id__goals__target_surah_id');

  $$GoalsTableProcessedTableManager get goalsRefs {
    final manager = $$GoalsTableTableManager($_db, $_db.goals)
        .filter((f) => f.targetSurahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MemorizedRangesTable, List<MemorizedRange>>
      _memorizedRangesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.memorizedRanges,
              aliasName: 'surahs__id__memorized_ranges__surah_id');

  $$MemorizedRangesTableProcessedTableManager get memorizedRangesRefs {
    final manager =
        $$MemorizedRangesTableTableManager($_db, $_db.memorizedRanges)
            .filter((f) => f.surahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_memorizedRangesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

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

  Expression<bool> juzSurahRangesRefs(
      Expression<bool> Function($$JuzSurahRangesTableFilterComposer f) f) {
    final $$JuzSurahRangesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.juzSurahRanges,
        getReferencedColumn: (t) => t.surahId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JuzSurahRangesTableFilterComposer(
              $db: $db,
              $table: $db.juzSurahRanges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessionMemorizationsRefs(
      Expression<bool> Function($$SessionMemorizationsTableFilterComposer f)
          f) {
    final $$SessionMemorizationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionMemorizations,
        getReferencedColumn: (t) => t.surahId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionMemorizationsTableFilterComposer(
              $db: $db,
              $table: $db.sessionMemorizations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessionRevisionsRefs(
      Expression<bool> Function($$SessionRevisionsTableFilterComposer f) f) {
    final $$SessionRevisionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionRevisions,
        getReferencedColumn: (t) => t.surahId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionRevisionsTableFilterComposer(
              $db: $db,
              $table: $db.sessionRevisions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> goalsRefs(
      Expression<bool> Function($$GoalsTableFilterComposer f) f) {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.targetSurahId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableFilterComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> memorizedRangesRefs(
      Expression<bool> Function($$MemorizedRangesTableFilterComposer f) f) {
    final $$MemorizedRangesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.memorizedRanges,
        getReferencedColumn: (t) => t.surahId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MemorizedRangesTableFilterComposer(
              $db: $db,
              $table: $db.memorizedRanges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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

  Expression<T> juzSurahRangesRefs<T extends Object>(
      Expression<T> Function($$JuzSurahRangesTableAnnotationComposer a) f) {
    final $$JuzSurahRangesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.juzSurahRanges,
        getReferencedColumn: (t) => t.surahId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JuzSurahRangesTableAnnotationComposer(
              $db: $db,
              $table: $db.juzSurahRanges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> sessionMemorizationsRefs<T extends Object>(
      Expression<T> Function($$SessionMemorizationsTableAnnotationComposer a)
          f) {
    final $$SessionMemorizationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.sessionMemorizations,
            getReferencedColumn: (t) => t.surahId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessionMemorizationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sessionMemorizations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> sessionRevisionsRefs<T extends Object>(
      Expression<T> Function($$SessionRevisionsTableAnnotationComposer a) f) {
    final $$SessionRevisionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionRevisions,
        getReferencedColumn: (t) => t.surahId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionRevisionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionRevisions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> goalsRefs<T extends Object>(
      Expression<T> Function($$GoalsTableAnnotationComposer a) f) {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.targetSurahId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableAnnotationComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> memorizedRangesRefs<T extends Object>(
      Expression<T> Function($$MemorizedRangesTableAnnotationComposer a) f) {
    final $$MemorizedRangesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.memorizedRanges,
        getReferencedColumn: (t) => t.surahId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MemorizedRangesTableAnnotationComposer(
              $db: $db,
              $table: $db.memorizedRanges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
    (Surah, $$SurahsTableReferences),
    Surah,
    PrefetchHooks Function(
        {bool juzSurahRangesRefs,
        bool sessionMemorizationsRefs,
        bool sessionRevisionsRefs,
        bool goalsRefs,
        bool memorizedRangesRefs})> {
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
              .map((e) =>
                  (e.readTable(table), $$SurahsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {juzSurahRangesRefs = false,
              sessionMemorizationsRefs = false,
              sessionRevisionsRefs = false,
              goalsRefs = false,
              memorizedRangesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (juzSurahRangesRefs) db.juzSurahRanges,
                if (sessionMemorizationsRefs) db.sessionMemorizations,
                if (sessionRevisionsRefs) db.sessionRevisions,
                if (goalsRefs) db.goals,
                if (memorizedRangesRefs) db.memorizedRanges
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (juzSurahRangesRefs)
                    await $_getPrefetchedData<Surah, $SurahsTable,
                            JuzSurahRange>(
                        currentTable: table,
                        referencedTable: $$SurahsTableReferences
                            ._juzSurahRangesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SurahsTableReferences(db, table, p0)
                                .juzSurahRangesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.surahId == item.id),
                        typedResults: items),
                  if (sessionMemorizationsRefs)
                    await $_getPrefetchedData<Surah, $SurahsTable,
                            SessionMemorization>(
                        currentTable: table,
                        referencedTable: $$SurahsTableReferences
                            ._sessionMemorizationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SurahsTableReferences(db, table, p0)
                                .sessionMemorizationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.surahId == item.id),
                        typedResults: items),
                  if (sessionRevisionsRefs)
                    await $_getPrefetchedData<Surah, $SurahsTable,
                            SessionRevision>(
                        currentTable: table,
                        referencedTable: $$SurahsTableReferences
                            ._sessionRevisionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SurahsTableReferences(db, table, p0)
                                .sessionRevisionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.surahId == item.id),
                        typedResults: items),
                  if (goalsRefs)
                    await $_getPrefetchedData<Surah, $SurahsTable, Goal>(
                        currentTable: table,
                        referencedTable:
                            $$SurahsTableReferences._goalsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SurahsTableReferences(db, table, p0).goalsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.targetSurahId == item.id),
                        typedResults: items),
                  if (memorizedRangesRefs)
                    await $_getPrefetchedData<Surah, $SurahsTable,
                            MemorizedRange>(
                        currentTable: table,
                        referencedTable: $$SurahsTableReferences
                            ._memorizedRangesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SurahsTableReferences(db, table, p0)
                                .memorizedRangesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.surahId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
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
    (Surah, $$SurahsTableReferences),
    Surah,
    PrefetchHooks Function(
        {bool juzSurahRangesRefs,
        bool sessionMemorizationsRefs,
        bool sessionRevisionsRefs,
        bool goalsRefs,
        bool memorizedRangesRefs})>;
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

final class $$JuzSurahRangesTableReferences
    extends BaseReferences<_$AppDatabase, $JuzSurahRangesTable, JuzSurahRange> {
  $$JuzSurahRangesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SurahsTable _surahIdTable(_$AppDatabase db) =>
      db.surahs.createAlias('juz_surah_ranges__surah_id__surahs__id');

  $$SurahsTableProcessedTableManager get surahId {
    final $_column = $_itemColumn<int>('surah_id')!;

    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

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

  ColumnFilters<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnFilters(column));

  $$SurahsTableFilterComposer get surahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  ColumnOrderings<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnOrderings(column));

  $$SurahsTableOrderingComposer get surahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<int> get fromAyah =>
      $composableBuilder(column: $table.fromAyah, builder: (column) => column);

  GeneratedColumn<int> get toAyah =>
      $composableBuilder(column: $table.toAyah, builder: (column) => column);

  $$SurahsTableAnnotationComposer get surahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (JuzSurahRange, $$JuzSurahRangesTableReferences),
    JuzSurahRange,
    PrefetchHooks Function({bool surahId})> {
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
              .map((e) => (
                    e.readTable(table),
                    $$JuzSurahRangesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({surahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (surahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.surahId,
                    referencedTable:
                        $$JuzSurahRangesTableReferences._surahIdTable(db),
                    referencedColumn:
                        $$JuzSurahRangesTableReferences._surahIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
    (JuzSurahRange, $$JuzSurahRangesTableReferences),
    JuzSurahRange,
    PrefetchHooks Function({bool surahId})>;
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

final class $$StudentsTableReferences
    extends BaseReferences<_$AppDatabase, $StudentsTable, Student> {
  $$StudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SurahsTable _currentSurahIdTable(_$AppDatabase db) =>
      db.surahs.createAlias('students__current_surah_id__surahs__id');

  $$SurahsTableProcessedTableManager? get currentSurahId {
    final $_column = $_itemColumn<int>('current_surah_id');
    if ($_column == null) return null;
    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currentSurahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SurahsTable _lastCompletedSurahIdTable(_$AppDatabase db) =>
      db.surahs.createAlias('students__last_completed_surah_id__surahs__id');

  $$SurahsTableProcessedTableManager? get lastCompletedSurahId {
    final $_column = $_itemColumn<int>('last_completed_surah_id');
    if ($_column == null) return null;
    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_lastCompletedSurahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sessions,
          aliasName: 'students__id__sessions__student_id');

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessionAttendancesTable, List<SessionAttendance>>
      _sessionAttendancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionAttendances,
              aliasName: 'students__id__session_attendances__student_id');

  $$SessionAttendancesTableProcessedTableManager get sessionAttendancesRefs {
    final manager =
        $$SessionAttendancesTableTableManager($_db, $_db.sessionAttendances)
            .filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sessionAttendancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SchedulesTable, List<Schedule>>
      _schedulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.schedules,
              aliasName: 'students__id__schedules__student_id');

  $$SchedulesTableProcessedTableManager get schedulesRefs {
    final manager = $$SchedulesTableTableManager($_db, $_db.schedules)
        .filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_schedulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GoalsTable, List<Goal>> _goalsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.goals,
          aliasName: 'students__id__goals__student_id');

  $$GoalsTableProcessedTableManager get goalsRefs {
    final manager = $$GoalsTableTableManager($_db, $_db.goals)
        .filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MemorizedRangesTable, List<MemorizedRange>>
      _memorizedRangesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.memorizedRanges,
              aliasName: 'students__id__memorized_ranges__student_id');

  $$MemorizedRangesTableProcessedTableManager get memorizedRangesRefs {
    final manager =
        $$MemorizedRangesTableTableManager($_db, $_db.memorizedRanges)
            .filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_memorizedRangesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GroupMembersTable, List<GroupMember>>
      _groupMembersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.groupMembers,
              aliasName: 'students__id__group_members__student_id');

  $$GroupMembersTableProcessedTableManager get groupMembersRefs {
    final manager = $$GroupMembersTableTableManager($_db, $_db.groupMembers)
        .filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMembersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$JuzQuarterProgressTable,
      List<JuzQuarterProgressData>> _juzQuarterProgressRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.juzQuarterProgress,
          aliasName: 'students__id__juz_quarter_progress__student_id');

  $$JuzQuarterProgressTableProcessedTableManager get juzQuarterProgressRefs {
    final manager =
        $$JuzQuarterProgressTableTableManager($_db, $_db.juzQuarterProgress)
            .filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_juzQuarterProgressRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

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

  ColumnFilters<int> get totalCompletedJuz => $composableBuilder(
      column: $table.totalCompletedJuz,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SurahsTableFilterComposer get currentSurahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currentSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableFilterComposer get lastCompletedSurahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lastCompletedSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> sessionsRefs(
      Expression<bool> Function($$SessionsTableFilterComposer f) f) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessionAttendancesRefs(
      Expression<bool> Function($$SessionAttendancesTableFilterComposer f) f) {
    final $$SessionAttendancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionAttendances,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionAttendancesTableFilterComposer(
              $db: $db,
              $table: $db.sessionAttendances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> schedulesRefs(
      Expression<bool> Function($$SchedulesTableFilterComposer f) f) {
    final $$SchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schedules,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedulesTableFilterComposer(
              $db: $db,
              $table: $db.schedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> goalsRefs(
      Expression<bool> Function($$GoalsTableFilterComposer f) f) {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableFilterComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> memorizedRangesRefs(
      Expression<bool> Function($$MemorizedRangesTableFilterComposer f) f) {
    final $$MemorizedRangesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.memorizedRanges,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MemorizedRangesTableFilterComposer(
              $db: $db,
              $table: $db.memorizedRanges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> groupMembersRefs(
      Expression<bool> Function($$GroupMembersTableFilterComposer f) f) {
    final $$GroupMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupMembers,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupMembersTableFilterComposer(
              $db: $db,
              $table: $db.groupMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> juzQuarterProgressRefs(
      Expression<bool> Function($$JuzQuarterProgressTableFilterComposer f) f) {
    final $$JuzQuarterProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.juzQuarterProgress,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JuzQuarterProgressTableFilterComposer(
              $db: $db,
              $table: $db.juzQuarterProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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

  ColumnOrderings<int> get totalCompletedJuz => $composableBuilder(
      column: $table.totalCompletedJuz,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SurahsTableOrderingComposer get currentSurahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currentSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableOrderingComposer get lastCompletedSurahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lastCompletedSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<int> get totalCompletedJuz => $composableBuilder(
      column: $table.totalCompletedJuz, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SurahsTableAnnotationComposer get currentSurahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currentSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableAnnotationComposer get lastCompletedSurahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lastCompletedSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> sessionsRefs<T extends Object>(
      Expression<T> Function($$SessionsTableAnnotationComposer a) f) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> sessionAttendancesRefs<T extends Object>(
      Expression<T> Function($$SessionAttendancesTableAnnotationComposer a) f) {
    final $$SessionAttendancesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.sessionAttendances,
            getReferencedColumn: (t) => t.studentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessionAttendancesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sessionAttendances,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> schedulesRefs<T extends Object>(
      Expression<T> Function($$SchedulesTableAnnotationComposer a) f) {
    final $$SchedulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schedules,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedulesTableAnnotationComposer(
              $db: $db,
              $table: $db.schedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> goalsRefs<T extends Object>(
      Expression<T> Function($$GoalsTableAnnotationComposer a) f) {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableAnnotationComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> memorizedRangesRefs<T extends Object>(
      Expression<T> Function($$MemorizedRangesTableAnnotationComposer a) f) {
    final $$MemorizedRangesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.memorizedRanges,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MemorizedRangesTableAnnotationComposer(
              $db: $db,
              $table: $db.memorizedRanges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> groupMembersRefs<T extends Object>(
      Expression<T> Function($$GroupMembersTableAnnotationComposer a) f) {
    final $$GroupMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupMembers,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.groupMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> juzQuarterProgressRefs<T extends Object>(
      Expression<T> Function($$JuzQuarterProgressTableAnnotationComposer a) f) {
    final $$JuzQuarterProgressTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.juzQuarterProgress,
            getReferencedColumn: (t) => t.studentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JuzQuarterProgressTableAnnotationComposer(
                  $db: $db,
                  $table: $db.juzQuarterProgress,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
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
    (Student, $$StudentsTableReferences),
    Student,
    PrefetchHooks Function(
        {bool currentSurahId,
        bool lastCompletedSurahId,
        bool sessionsRefs,
        bool sessionAttendancesRefs,
        bool schedulesRefs,
        bool goalsRefs,
        bool memorizedRangesRefs,
        bool groupMembersRefs,
        bool juzQuarterProgressRefs})> {
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
              .map((e) =>
                  (e.readTable(table), $$StudentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {currentSurahId = false,
              lastCompletedSurahId = false,
              sessionsRefs = false,
              sessionAttendancesRefs = false,
              schedulesRefs = false,
              goalsRefs = false,
              memorizedRangesRefs = false,
              groupMembersRefs = false,
              juzQuarterProgressRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionsRefs) db.sessions,
                if (sessionAttendancesRefs) db.sessionAttendances,
                if (schedulesRefs) db.schedules,
                if (goalsRefs) db.goals,
                if (memorizedRangesRefs) db.memorizedRanges,
                if (groupMembersRefs) db.groupMembers,
                if (juzQuarterProgressRefs) db.juzQuarterProgress
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currentSurahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currentSurahId,
                    referencedTable:
                        $$StudentsTableReferences._currentSurahIdTable(db),
                    referencedColumn:
                        $$StudentsTableReferences._currentSurahIdTable(db).id,
                  ) as T;
                }
                if (lastCompletedSurahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lastCompletedSurahId,
                    referencedTable: $$StudentsTableReferences
                        ._lastCompletedSurahIdTable(db),
                    referencedColumn: $$StudentsTableReferences
                        ._lastCompletedSurahIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<Student, $StudentsTable, Session>(
                        currentTable: table,
                        referencedTable:
                            $$StudentsTableReferences._sessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StudentsTableReferences(db, table, p0)
                                .sessionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.studentId == item.id),
                        typedResults: items),
                  if (sessionAttendancesRefs)
                    await $_getPrefetchedData<Student, $StudentsTable,
                            SessionAttendance>(
                        currentTable: table,
                        referencedTable: $$StudentsTableReferences
                            ._sessionAttendancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StudentsTableReferences(db, table, p0)
                                .sessionAttendancesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.studentId == item.id),
                        typedResults: items),
                  if (schedulesRefs)
                    await $_getPrefetchedData<Student, $StudentsTable,
                            Schedule>(
                        currentTable: table,
                        referencedTable:
                            $$StudentsTableReferences._schedulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StudentsTableReferences(db, table, p0)
                                .schedulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.studentId == item.id),
                        typedResults: items),
                  if (goalsRefs)
                    await $_getPrefetchedData<Student, $StudentsTable, Goal>(
                        currentTable: table,
                        referencedTable:
                            $$StudentsTableReferences._goalsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StudentsTableReferences(db, table, p0).goalsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.studentId == item.id),
                        typedResults: items),
                  if (memorizedRangesRefs)
                    await $_getPrefetchedData<Student, $StudentsTable,
                            MemorizedRange>(
                        currentTable: table,
                        referencedTable: $$StudentsTableReferences
                            ._memorizedRangesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StudentsTableReferences(db, table, p0)
                                .memorizedRangesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.studentId == item.id),
                        typedResults: items),
                  if (groupMembersRefs)
                    await $_getPrefetchedData<Student, $StudentsTable,
                            GroupMember>(
                        currentTable: table,
                        referencedTable: $$StudentsTableReferences
                            ._groupMembersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StudentsTableReferences(db, table, p0)
                                .groupMembersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.studentId == item.id),
                        typedResults: items),
                  if (juzQuarterProgressRefs)
                    await $_getPrefetchedData<Student, $StudentsTable,
                            JuzQuarterProgressData>(
                        currentTable: table,
                        referencedTable: $$StudentsTableReferences
                            ._juzQuarterProgressRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StudentsTableReferences(db, table, p0)
                                .juzQuarterProgressRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.studentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
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
    (Student, $$StudentsTableReferences),
    Student,
    PrefetchHooks Function(
        {bool currentSurahId,
        bool lastCompletedSurahId,
        bool sessionsRefs,
        bool sessionAttendancesRefs,
        bool schedulesRefs,
        bool goalsRefs,
        bool memorizedRangesRefs,
        bool groupMembersRefs,
        bool juzQuarterProgressRefs})>;
typedef $$GroupsTableCreateCompanionBuilder = GroupsCompanion Function({
  Value<int> id,
  required String name,
  Value<int?> teacherId,
  Value<DateTime> createdAt,
});
typedef $$GroupsTableUpdateCompanionBuilder = GroupsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int?> teacherId,
  Value<DateTime> createdAt,
});

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, Group> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _teacherIdTable(_$AppDatabase db) =>
      db.users.createAlias('groups__teacher_id__users__id');

  $$UsersTableProcessedTableManager? get teacherId {
    final $_column = $_itemColumn<int>('teacher_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teacherIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sessions,
          aliasName: 'groups__id__sessions__group_id');

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GroupMembersTable, List<GroupMember>>
      _groupMembersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.groupMembers,
              aliasName: 'groups__id__group_members__group_id');

  $$GroupMembersTableProcessedTableManager get groupMembersRefs {
    final manager = $$GroupMembersTableTableManager($_db, $_db.groupMembers)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMembersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GroupScheduleSlotsTable, List<GroupScheduleSlot>>
      _groupScheduleSlotsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.groupScheduleSlots,
              aliasName: 'groups__id__group_schedule_slots__group_id');

  $$GroupScheduleSlotsTableProcessedTableManager get groupScheduleSlotsRefs {
    final manager =
        $$GroupScheduleSlotsTableTableManager($_db, $_db.groupScheduleSlots)
            .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_groupScheduleSlotsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get teacherId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.teacherId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> sessionsRefs(
      Expression<bool> Function($$SessionsTableFilterComposer f) f) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> groupMembersRefs(
      Expression<bool> Function($$GroupMembersTableFilterComposer f) f) {
    final $$GroupMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupMembers,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupMembersTableFilterComposer(
              $db: $db,
              $table: $db.groupMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> groupScheduleSlotsRefs(
      Expression<bool> Function($$GroupScheduleSlotsTableFilterComposer f) f) {
    final $$GroupScheduleSlotsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupScheduleSlots,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupScheduleSlotsTableFilterComposer(
              $db: $db,
              $table: $db.groupScheduleSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get teacherId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.teacherId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get teacherId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.teacherId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> sessionsRefs<T extends Object>(
      Expression<T> Function($$SessionsTableAnnotationComposer a) f) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> groupMembersRefs<T extends Object>(
      Expression<T> Function($$GroupMembersTableAnnotationComposer a) f) {
    final $$GroupMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupMembers,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.groupMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> groupScheduleSlotsRefs<T extends Object>(
      Expression<T> Function($$GroupScheduleSlotsTableAnnotationComposer a) f) {
    final $$GroupScheduleSlotsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.groupScheduleSlots,
            getReferencedColumn: (t) => t.groupId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GroupScheduleSlotsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.groupScheduleSlots,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$GroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, $$GroupsTableReferences),
    Group,
    PrefetchHooks Function(
        {bool teacherId,
        bool sessionsRefs,
        bool groupMembersRefs,
        bool groupScheduleSlotsRefs})> {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> teacherId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GroupsCompanion(
            id: id,
            name: name,
            teacherId: teacherId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int?> teacherId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GroupsCompanion.insert(
            id: id,
            name: name,
            teacherId: teacherId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GroupsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {teacherId = false,
              sessionsRefs = false,
              groupMembersRefs = false,
              groupScheduleSlotsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionsRefs) db.sessions,
                if (groupMembersRefs) db.groupMembers,
                if (groupScheduleSlotsRefs) db.groupScheduleSlots
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (teacherId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.teacherId,
                    referencedTable:
                        $$GroupsTableReferences._teacherIdTable(db),
                    referencedColumn:
                        $$GroupsTableReferences._teacherIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, Session>(
                        currentTable: table,
                        referencedTable:
                            $$GroupsTableReferences._sessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0).sessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (groupMembersRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, GroupMember>(
                        currentTable: table,
                        referencedTable:
                            $$GroupsTableReferences._groupMembersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0)
                                .groupMembersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (groupScheduleSlotsRefs)
                    await $_getPrefetchedData<Group, $GroupsTable,
                            GroupScheduleSlot>(
                        currentTable: table,
                        referencedTable: $$GroupsTableReferences
                            ._groupScheduleSlotsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0)
                                .groupScheduleSlotsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, $$GroupsTableReferences),
    Group,
    PrefetchHooks Function(
        {bool teacherId,
        bool sessionsRefs,
        bool groupMembersRefs,
        bool groupScheduleSlotsRefs})>;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int?> studentId,
  Value<int?> groupId,
  Value<String> sessionType,
  Value<DateTime?> occurrenceDate,
  required DateTime date,
  required String time,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int?> studentId,
  Value<int?> groupId,
  Value<String> sessionType,
  Value<DateTime?> occurrenceDate,
  Value<DateTime> date,
  Value<String> time,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('sessions__student_id__students__id');

  $$StudentsTableProcessedTableManager? get studentId {
    final $_column = $_itemColumn<int>('student_id');
    if ($_column == null) return null;
    final manager = $$StudentsTableTableManager($_db, $_db.students)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('sessions__group_id__groups__id');

  $$GroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<int>('group_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SessionMemorizationsTable,
      List<SessionMemorization>> _sessionMemorizationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sessionMemorizations,
          aliasName: 'sessions__id__session_memorizations__session_id');

  $$SessionMemorizationsTableProcessedTableManager
      get sessionMemorizationsRefs {
    final manager =
        $$SessionMemorizationsTableTableManager($_db, $_db.sessionMemorizations)
            .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sessionMemorizationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessionRevisionsTable, List<SessionRevision>>
      _sessionRevisionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionRevisions,
              aliasName: 'sessions__id__session_revisions__session_id');

  $$SessionRevisionsTableProcessedTableManager get sessionRevisionsRefs {
    final manager =
        $$SessionRevisionsTableTableManager($_db, $_db.sessionRevisions)
            .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sessionRevisionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessionEvaluationsTable, List<SessionEvaluation>>
      _sessionEvaluationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionEvaluations,
              aliasName: 'sessions__id__session_evaluations__session_id');

  $$SessionEvaluationsTableProcessedTableManager get sessionEvaluationsRefs {
    final manager =
        $$SessionEvaluationsTableTableManager($_db, $_db.sessionEvaluations)
            .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sessionEvaluationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessionAttendancesTable, List<SessionAttendance>>
      _sessionAttendancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionAttendances,
              aliasName: 'sessions__id__session_attendances__session_id');

  $$SessionAttendancesTableProcessedTableManager get sessionAttendancesRefs {
    final manager =
        $$SessionAttendancesTableTableManager($_db, $_db.sessionAttendances)
            .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sessionAttendancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

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

  ColumnFilters<String> get sessionType => $composableBuilder(
      column: $table.sessionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurrenceDate => $composableBuilder(
      column: $table.occurrenceDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableFilterComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> sessionMemorizationsRefs(
      Expression<bool> Function($$SessionMemorizationsTableFilterComposer f)
          f) {
    final $$SessionMemorizationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionMemorizations,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionMemorizationsTableFilterComposer(
              $db: $db,
              $table: $db.sessionMemorizations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessionRevisionsRefs(
      Expression<bool> Function($$SessionRevisionsTableFilterComposer f) f) {
    final $$SessionRevisionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionRevisions,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionRevisionsTableFilterComposer(
              $db: $db,
              $table: $db.sessionRevisions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessionEvaluationsRefs(
      Expression<bool> Function($$SessionEvaluationsTableFilterComposer f) f) {
    final $$SessionEvaluationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionEvaluations,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionEvaluationsTableFilterComposer(
              $db: $db,
              $table: $db.sessionEvaluations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessionAttendancesRefs(
      Expression<bool> Function($$SessionAttendancesTableFilterComposer f) f) {
    final $$SessionAttendancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionAttendances,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionAttendancesTableFilterComposer(
              $db: $db,
              $table: $db.sessionAttendances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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

  ColumnOrderings<String> get sessionType => $composableBuilder(
      column: $table.sessionType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurrenceDate => $composableBuilder(
      column: $table.occurrenceDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableOrderingComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<String> get sessionType => $composableBuilder(
      column: $table.sessionType, builder: (column) => column);

  GeneratedColumn<DateTime> get occurrenceDate => $composableBuilder(
      column: $table.occurrenceDate, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> sessionMemorizationsRefs<T extends Object>(
      Expression<T> Function($$SessionMemorizationsTableAnnotationComposer a)
          f) {
    final $$SessionMemorizationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.sessionMemorizations,
            getReferencedColumn: (t) => t.sessionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessionMemorizationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sessionMemorizations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> sessionRevisionsRefs<T extends Object>(
      Expression<T> Function($$SessionRevisionsTableAnnotationComposer a) f) {
    final $$SessionRevisionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionRevisions,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionRevisionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionRevisions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> sessionEvaluationsRefs<T extends Object>(
      Expression<T> Function($$SessionEvaluationsTableAnnotationComposer a) f) {
    final $$SessionEvaluationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.sessionEvaluations,
            getReferencedColumn: (t) => t.sessionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessionEvaluationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sessionEvaluations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> sessionAttendancesRefs<T extends Object>(
      Expression<T> Function($$SessionAttendancesTableAnnotationComposer a) f) {
    final $$SessionAttendancesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.sessionAttendances,
            getReferencedColumn: (t) => t.sessionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessionAttendancesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sessionAttendances,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
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
    (Session, $$SessionsTableReferences),
    Session,
    PrefetchHooks Function(
        {bool studentId,
        bool groupId,
        bool sessionMemorizationsRefs,
        bool sessionRevisionsRefs,
        bool sessionEvaluationsRefs,
        bool sessionAttendancesRefs})> {
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
            Value<int?> studentId = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            Value<String> sessionType = const Value.absent(),
            Value<DateTime?> occurrenceDate = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> time = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            studentId: studentId,
            groupId: groupId,
            sessionType: sessionType,
            occurrenceDate: occurrenceDate,
            date: date,
            time: time,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> studentId = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            Value<String> sessionType = const Value.absent(),
            Value<DateTime?> occurrenceDate = const Value.absent(),
            required DateTime date,
            required String time,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SessionsCompanion.insert(
            id: id,
            studentId: studentId,
            groupId: groupId,
            sessionType: sessionType,
            occurrenceDate: occurrenceDate,
            date: date,
            time: time,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SessionsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {studentId = false,
              groupId = false,
              sessionMemorizationsRefs = false,
              sessionRevisionsRefs = false,
              sessionEvaluationsRefs = false,
              sessionAttendancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionMemorizationsRefs) db.sessionMemorizations,
                if (sessionRevisionsRefs) db.sessionRevisions,
                if (sessionEvaluationsRefs) db.sessionEvaluations,
                if (sessionAttendancesRefs) db.sessionAttendances
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (studentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.studentId,
                    referencedTable:
                        $$SessionsTableReferences._studentIdTable(db),
                    referencedColumn:
                        $$SessionsTableReferences._studentIdTable(db).id,
                  ) as T;
                }
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$SessionsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$SessionsTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionMemorizationsRefs)
                    await $_getPrefetchedData<Session, $SessionsTable,
                            SessionMemorization>(
                        currentTable: table,
                        referencedTable: $$SessionsTableReferences
                            ._sessionMemorizationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SessionsTableReferences(db, table, p0)
                                .sessionMemorizationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items),
                  if (sessionRevisionsRefs)
                    await $_getPrefetchedData<Session, $SessionsTable,
                            SessionRevision>(
                        currentTable: table,
                        referencedTable: $$SessionsTableReferences
                            ._sessionRevisionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SessionsTableReferences(db, table, p0)
                                .sessionRevisionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items),
                  if (sessionEvaluationsRefs)
                    await $_getPrefetchedData<Session, $SessionsTable,
                            SessionEvaluation>(
                        currentTable: table,
                        referencedTable: $$SessionsTableReferences
                            ._sessionEvaluationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SessionsTableReferences(db, table, p0)
                                .sessionEvaluationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items),
                  if (sessionAttendancesRefs)
                    await $_getPrefetchedData<Session, $SessionsTable,
                            SessionAttendance>(
                        currentTable: table,
                        referencedTable: $$SessionsTableReferences
                            ._sessionAttendancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SessionsTableReferences(db, table, p0)
                                .sessionAttendancesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
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
    (Session, $$SessionsTableReferences),
    Session,
    PrefetchHooks Function(
        {bool studentId,
        bool groupId,
        bool sessionMemorizationsRefs,
        bool sessionRevisionsRefs,
        bool sessionEvaluationsRefs,
        bool sessionAttendancesRefs})>;
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

final class $$SessionMemorizationsTableReferences extends BaseReferences<
    _$AppDatabase, $SessionMemorizationsTable, SessionMemorization> {
  $$SessionMemorizationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) => db.sessions
      .createAlias('session_memorizations__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SurahsTable _surahIdTable(_$AppDatabase db) =>
      db.surahs.createAlias('session_memorizations__surah_id__surahs__id');

  $$SurahsTableProcessedTableManager get surahId {
    final $_column = $_itemColumn<int>('surah_id')!;

    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

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

  ColumnFilters<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnFilters(column));

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableFilterComposer get surahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  ColumnOrderings<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnOrderings(column));

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableOrderingComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableOrderingComposer get surahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<int> get fromAyah =>
      $composableBuilder(column: $table.fromAyah, builder: (column) => column);

  GeneratedColumn<int> get toAyah =>
      $composableBuilder(column: $table.toAyah, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableAnnotationComposer get surahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (SessionMemorization, $$SessionMemorizationsTableReferences),
    SessionMemorization,
    PrefetchHooks Function({bool sessionId, bool surahId})> {
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
              .map((e) => (
                    e.readTable(table),
                    $$SessionMemorizationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false, surahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable: $$SessionMemorizationsTableReferences
                        ._sessionIdTable(db),
                    referencedColumn: $$SessionMemorizationsTableReferences
                        ._sessionIdTable(db)
                        .id,
                  ) as T;
                }
                if (surahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.surahId,
                    referencedTable:
                        $$SessionMemorizationsTableReferences._surahIdTable(db),
                    referencedColumn: $$SessionMemorizationsTableReferences
                        ._surahIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
        (SessionMemorization, $$SessionMemorizationsTableReferences),
        SessionMemorization,
        PrefetchHooks Function({bool sessionId, bool surahId})>;
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

final class $$SessionRevisionsTableReferences extends BaseReferences<
    _$AppDatabase, $SessionRevisionsTable, SessionRevision> {
  $$SessionRevisionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('session_revisions__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SurahsTable _surahIdTable(_$AppDatabase db) =>
      db.surahs.createAlias('session_revisions__surah_id__surahs__id');

  $$SurahsTableProcessedTableManager get surahId {
    final $_column = $_itemColumn<int>('surah_id')!;

    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

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

  ColumnFilters<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnFilters(column));

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableFilterComposer get surahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  ColumnOrderings<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnOrderings(column));

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableOrderingComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableOrderingComposer get surahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<int> get fromAyah =>
      $composableBuilder(column: $table.fromAyah, builder: (column) => column);

  GeneratedColumn<int> get toAyah =>
      $composableBuilder(column: $table.toAyah, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableAnnotationComposer get surahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (SessionRevision, $$SessionRevisionsTableReferences),
    SessionRevision,
    PrefetchHooks Function({bool sessionId, bool surahId})> {
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
              .map((e) => (
                    e.readTable(table),
                    $$SessionRevisionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false, surahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$SessionRevisionsTableReferences._sessionIdTable(db),
                    referencedColumn: $$SessionRevisionsTableReferences
                        ._sessionIdTable(db)
                        .id,
                  ) as T;
                }
                if (surahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.surahId,
                    referencedTable:
                        $$SessionRevisionsTableReferences._surahIdTable(db),
                    referencedColumn:
                        $$SessionRevisionsTableReferences._surahIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
    (SessionRevision, $$SessionRevisionsTableReferences),
    SessionRevision,
    PrefetchHooks Function({bool sessionId, bool surahId})>;
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

final class $$SessionEvaluationsTableReferences extends BaseReferences<
    _$AppDatabase, $SessionEvaluationsTable, SessionEvaluation> {
  $$SessionEvaluationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('session_evaluations__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

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

  ColumnFilters<double> get memorizationScore => $composableBuilder(
      column: $table.memorizationScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tajweedScore => $composableBuilder(
      column: $table.tajweedScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fluencyScore => $composableBuilder(
      column: $table.fluencyScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracyScore => $composableBuilder(
      column: $table.accuracyScore, builder: (column) => ColumnFilters(column));

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableOrderingComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<double> get memorizationScore => $composableBuilder(
      column: $table.memorizationScore, builder: (column) => column);

  GeneratedColumn<double> get tajweedScore => $composableBuilder(
      column: $table.tajweedScore, builder: (column) => column);

  GeneratedColumn<double> get fluencyScore => $composableBuilder(
      column: $table.fluencyScore, builder: (column) => column);

  GeneratedColumn<double> get accuracyScore => $composableBuilder(
      column: $table.accuracyScore, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (SessionEvaluation, $$SessionEvaluationsTableReferences),
    SessionEvaluation,
    PrefetchHooks Function({bool sessionId})> {
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
              .map((e) => (
                    e.readTable(table),
                    $$SessionEvaluationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$SessionEvaluationsTableReferences._sessionIdTable(db),
                    referencedColumn: $$SessionEvaluationsTableReferences
                        ._sessionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
    (SessionEvaluation, $$SessionEvaluationsTableReferences),
    SessionEvaluation,
    PrefetchHooks Function({bool sessionId})>;
typedef $$SessionAttendancesTableCreateCompanionBuilder
    = SessionAttendancesCompanion Function({
  Value<int> id,
  required int sessionId,
  required int studentId,
  Value<String> attendanceStatus,
  Value<int?> memorizationSurahId,
  Value<int?> memorizationFromAyah,
  Value<int?> memorizationToAyah,
  Value<int?> revisionSurahId,
  Value<int?> revisionFromAyah,
  Value<int?> revisionToAyah,
  Value<double> memorizationScore,
  Value<double> tajweedScore,
  Value<double> fluencyScore,
  Value<double> accuracyScore,
  Value<String?> notes,
  Value<String?> recitationOutcome,
  Value<DateTime> createdAt,
});
typedef $$SessionAttendancesTableUpdateCompanionBuilder
    = SessionAttendancesCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> studentId,
  Value<String> attendanceStatus,
  Value<int?> memorizationSurahId,
  Value<int?> memorizationFromAyah,
  Value<int?> memorizationToAyah,
  Value<int?> revisionSurahId,
  Value<int?> revisionFromAyah,
  Value<int?> revisionToAyah,
  Value<double> memorizationScore,
  Value<double> tajweedScore,
  Value<double> fluencyScore,
  Value<double> accuracyScore,
  Value<String?> notes,
  Value<String?> recitationOutcome,
  Value<DateTime> createdAt,
});

final class $$SessionAttendancesTableReferences extends BaseReferences<
    _$AppDatabase, $SessionAttendancesTable, SessionAttendance> {
  $$SessionAttendancesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('session_attendances__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('session_attendances__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager($_db, $_db.students)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SurahsTable _memorizationSurahIdTable(_$AppDatabase db) => db.surahs
      .createAlias('session_attendances__memorization_surah_id__surahs__id');

  $$SurahsTableProcessedTableManager? get memorizationSurahId {
    final $_column = $_itemColumn<int>('memorization_surah_id');
    if ($_column == null) return null;
    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memorizationSurahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SurahsTable _revisionSurahIdTable(_$AppDatabase db) => db.surahs
      .createAlias('session_attendances__revision_surah_id__surahs__id');

  $$SurahsTableProcessedTableManager? get revisionSurahId {
    final $_column = $_itemColumn<int>('revision_surah_id');
    if ($_column == null) return null;
    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_revisionSurahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SessionAttendancesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionAttendancesTable> {
  $$SessionAttendancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attendanceStatus => $composableBuilder(
      column: $table.attendanceStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memorizationFromAyah => $composableBuilder(
      column: $table.memorizationFromAyah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memorizationToAyah => $composableBuilder(
      column: $table.memorizationToAyah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revisionFromAyah => $composableBuilder(
      column: $table.revisionFromAyah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revisionToAyah => $composableBuilder(
      column: $table.revisionToAyah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get memorizationScore => $composableBuilder(
      column: $table.memorizationScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tajweedScore => $composableBuilder(
      column: $table.tajweedScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fluencyScore => $composableBuilder(
      column: $table.fluencyScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracyScore => $composableBuilder(
      column: $table.accuracyScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recitationOutcome => $composableBuilder(
      column: $table.recitationOutcome,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableFilterComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableFilterComposer get memorizationSurahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memorizationSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableFilterComposer get revisionSurahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.revisionSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionAttendancesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionAttendancesTable> {
  $$SessionAttendancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attendanceStatus => $composableBuilder(
      column: $table.attendanceStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memorizationFromAyah => $composableBuilder(
      column: $table.memorizationFromAyah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memorizationToAyah => $composableBuilder(
      column: $table.memorizationToAyah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revisionFromAyah => $composableBuilder(
      column: $table.revisionFromAyah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revisionToAyah => $composableBuilder(
      column: $table.revisionToAyah,
      builder: (column) => ColumnOrderings(column));

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

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recitationOutcome => $composableBuilder(
      column: $table.recitationOutcome,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableOrderingComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableOrderingComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableOrderingComposer get memorizationSurahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memorizationSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableOrderingComposer get revisionSurahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.revisionSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionAttendancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionAttendancesTable> {
  $$SessionAttendancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get attendanceStatus => $composableBuilder(
      column: $table.attendanceStatus, builder: (column) => column);

  GeneratedColumn<int> get memorizationFromAyah => $composableBuilder(
      column: $table.memorizationFromAyah, builder: (column) => column);

  GeneratedColumn<int> get memorizationToAyah => $composableBuilder(
      column: $table.memorizationToAyah, builder: (column) => column);

  GeneratedColumn<int> get revisionFromAyah => $composableBuilder(
      column: $table.revisionFromAyah, builder: (column) => column);

  GeneratedColumn<int> get revisionToAyah => $composableBuilder(
      column: $table.revisionToAyah, builder: (column) => column);

  GeneratedColumn<double> get memorizationScore => $composableBuilder(
      column: $table.memorizationScore, builder: (column) => column);

  GeneratedColumn<double> get tajweedScore => $composableBuilder(
      column: $table.tajweedScore, builder: (column) => column);

  GeneratedColumn<double> get fluencyScore => $composableBuilder(
      column: $table.fluencyScore, builder: (column) => column);

  GeneratedColumn<double> get accuracyScore => $composableBuilder(
      column: $table.accuracyScore, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get recitationOutcome => $composableBuilder(
      column: $table.recitationOutcome, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableAnnotationComposer get memorizationSurahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memorizationSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableAnnotationComposer get revisionSurahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.revisionSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionAttendancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionAttendancesTable,
    SessionAttendance,
    $$SessionAttendancesTableFilterComposer,
    $$SessionAttendancesTableOrderingComposer,
    $$SessionAttendancesTableAnnotationComposer,
    $$SessionAttendancesTableCreateCompanionBuilder,
    $$SessionAttendancesTableUpdateCompanionBuilder,
    (SessionAttendance, $$SessionAttendancesTableReferences),
    SessionAttendance,
    PrefetchHooks Function(
        {bool sessionId,
        bool studentId,
        bool memorizationSurahId,
        bool revisionSurahId})> {
  $$SessionAttendancesTableTableManager(
      _$AppDatabase db, $SessionAttendancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionAttendancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionAttendancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionAttendancesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<String> attendanceStatus = const Value.absent(),
            Value<int?> memorizationSurahId = const Value.absent(),
            Value<int?> memorizationFromAyah = const Value.absent(),
            Value<int?> memorizationToAyah = const Value.absent(),
            Value<int?> revisionSurahId = const Value.absent(),
            Value<int?> revisionFromAyah = const Value.absent(),
            Value<int?> revisionToAyah = const Value.absent(),
            Value<double> memorizationScore = const Value.absent(),
            Value<double> tajweedScore = const Value.absent(),
            Value<double> fluencyScore = const Value.absent(),
            Value<double> accuracyScore = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> recitationOutcome = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SessionAttendancesCompanion(
            id: id,
            sessionId: sessionId,
            studentId: studentId,
            attendanceStatus: attendanceStatus,
            memorizationSurahId: memorizationSurahId,
            memorizationFromAyah: memorizationFromAyah,
            memorizationToAyah: memorizationToAyah,
            revisionSurahId: revisionSurahId,
            revisionFromAyah: revisionFromAyah,
            revisionToAyah: revisionToAyah,
            memorizationScore: memorizationScore,
            tajweedScore: tajweedScore,
            fluencyScore: fluencyScore,
            accuracyScore: accuracyScore,
            notes: notes,
            recitationOutcome: recitationOutcome,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int studentId,
            Value<String> attendanceStatus = const Value.absent(),
            Value<int?> memorizationSurahId = const Value.absent(),
            Value<int?> memorizationFromAyah = const Value.absent(),
            Value<int?> memorizationToAyah = const Value.absent(),
            Value<int?> revisionSurahId = const Value.absent(),
            Value<int?> revisionFromAyah = const Value.absent(),
            Value<int?> revisionToAyah = const Value.absent(),
            Value<double> memorizationScore = const Value.absent(),
            Value<double> tajweedScore = const Value.absent(),
            Value<double> fluencyScore = const Value.absent(),
            Value<double> accuracyScore = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> recitationOutcome = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SessionAttendancesCompanion.insert(
            id: id,
            sessionId: sessionId,
            studentId: studentId,
            attendanceStatus: attendanceStatus,
            memorizationSurahId: memorizationSurahId,
            memorizationFromAyah: memorizationFromAyah,
            memorizationToAyah: memorizationToAyah,
            revisionSurahId: revisionSurahId,
            revisionFromAyah: revisionFromAyah,
            revisionToAyah: revisionToAyah,
            memorizationScore: memorizationScore,
            tajweedScore: tajweedScore,
            fluencyScore: fluencyScore,
            accuracyScore: accuracyScore,
            notes: notes,
            recitationOutcome: recitationOutcome,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SessionAttendancesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sessionId = false,
              studentId = false,
              memorizationSurahId = false,
              revisionSurahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$SessionAttendancesTableReferences._sessionIdTable(db),
                    referencedColumn: $$SessionAttendancesTableReferences
                        ._sessionIdTable(db)
                        .id,
                  ) as T;
                }
                if (studentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.studentId,
                    referencedTable:
                        $$SessionAttendancesTableReferences._studentIdTable(db),
                    referencedColumn: $$SessionAttendancesTableReferences
                        ._studentIdTable(db)
                        .id,
                  ) as T;
                }
                if (memorizationSurahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.memorizationSurahId,
                    referencedTable: $$SessionAttendancesTableReferences
                        ._memorizationSurahIdTable(db),
                    referencedColumn: $$SessionAttendancesTableReferences
                        ._memorizationSurahIdTable(db)
                        .id,
                  ) as T;
                }
                if (revisionSurahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.revisionSurahId,
                    referencedTable: $$SessionAttendancesTableReferences
                        ._revisionSurahIdTable(db),
                    referencedColumn: $$SessionAttendancesTableReferences
                        ._revisionSurahIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SessionAttendancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionAttendancesTable,
    SessionAttendance,
    $$SessionAttendancesTableFilterComposer,
    $$SessionAttendancesTableOrderingComposer,
    $$SessionAttendancesTableAnnotationComposer,
    $$SessionAttendancesTableCreateCompanionBuilder,
    $$SessionAttendancesTableUpdateCompanionBuilder,
    (SessionAttendance, $$SessionAttendancesTableReferences),
    SessionAttendance,
    PrefetchHooks Function(
        {bool sessionId,
        bool studentId,
        bool memorizationSurahId,
        bool revisionSurahId})>;
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

final class $$SchedulesTableReferences
    extends BaseReferences<_$AppDatabase, $SchedulesTable, Schedule> {
  $$SchedulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('schedules__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager($_db, $_db.students)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SurahsTable _memorizationSurahIdTable(_$AppDatabase db) =>
      db.surahs.createAlias('schedules__memorization_surah_id__surahs__id');

  $$SurahsTableProcessedTableManager? get memorizationSurahId {
    final $_column = $_itemColumn<int>('memorization_surah_id');
    if ($_column == null) return null;
    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memorizationSurahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SurahsTable _revisionSurahIdTable(_$AppDatabase db) =>
      db.surahs.createAlias('schedules__revision_surah_id__surahs__id');

  $$SurahsTableProcessedTableManager? get revisionSurahId {
    final $_column = $_itemColumn<int>('revision_surah_id');
    if ($_column == null) return null;
    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_revisionSurahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

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

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memorizationFromAyah => $composableBuilder(
      column: $table.memorizationFromAyah,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memorizationToAyah => $composableBuilder(
      column: $table.memorizationToAyah,
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

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableFilterComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableFilterComposer get memorizationSurahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memorizationSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableFilterComposer get revisionSurahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.revisionSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memorizationFromAyah => $composableBuilder(
      column: $table.memorizationFromAyah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memorizationToAyah => $composableBuilder(
      column: $table.memorizationToAyah,
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

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableOrderingComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableOrderingComposer get memorizationSurahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memorizationSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableOrderingComposer get revisionSurahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.revisionSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get memorizationFromAyah => $composableBuilder(
      column: $table.memorizationFromAyah, builder: (column) => column);

  GeneratedColumn<int> get memorizationToAyah => $composableBuilder(
      column: $table.memorizationToAyah, builder: (column) => column);

  GeneratedColumn<int> get revisionFromAyah => $composableBuilder(
      column: $table.revisionFromAyah, builder: (column) => column);

  GeneratedColumn<int> get revisionToAyah => $composableBuilder(
      column: $table.revisionToAyah, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableAnnotationComposer get memorizationSurahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memorizationSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableAnnotationComposer get revisionSurahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.revisionSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (Schedule, $$SchedulesTableReferences),
    Schedule,
    PrefetchHooks Function(
        {bool studentId, bool memorizationSurahId, bool revisionSurahId})> {
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
              .map((e) => (
                    e.readTable(table),
                    $$SchedulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {studentId = false,
              memorizationSurahId = false,
              revisionSurahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (studentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.studentId,
                    referencedTable:
                        $$SchedulesTableReferences._studentIdTable(db),
                    referencedColumn:
                        $$SchedulesTableReferences._studentIdTable(db).id,
                  ) as T;
                }
                if (memorizationSurahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.memorizationSurahId,
                    referencedTable: $$SchedulesTableReferences
                        ._memorizationSurahIdTable(db),
                    referencedColumn: $$SchedulesTableReferences
                        ._memorizationSurahIdTable(db)
                        .id,
                  ) as T;
                }
                if (revisionSurahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.revisionSurahId,
                    referencedTable:
                        $$SchedulesTableReferences._revisionSurahIdTable(db),
                    referencedColumn:
                        $$SchedulesTableReferences._revisionSurahIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
    (Schedule, $$SchedulesTableReferences),
    Schedule,
    PrefetchHooks Function(
        {bool studentId, bool memorizationSurahId, bool revisionSurahId})>;
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

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('goals__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager($_db, $_db.students)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SurahsTable _targetSurahIdTable(_$AppDatabase db) =>
      db.surahs.createAlias('goals__target_surah_id__surahs__id');

  $$SurahsTableProcessedTableManager? get targetSurahId {
    final $_column = $_itemColumn<int>('target_surah_id');
    if ($_column == null) return null;
    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetSurahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

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

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalType => $composableBuilder(
      column: $table.goalType, builder: (column) => ColumnFilters(column));

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

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableFilterComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableFilterComposer get targetSurahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalType => $composableBuilder(
      column: $table.goalType, builder: (column) => ColumnOrderings(column));

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

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableOrderingComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableOrderingComposer get targetSurahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

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

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableAnnotationComposer get targetSurahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetSurahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (Goal, $$GoalsTableReferences),
    Goal,
    PrefetchHooks Function({bool studentId, bool targetSurahId})> {
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
              .map((e) =>
                  (e.readTable(table), $$GoalsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({studentId = false, targetSurahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (studentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.studentId,
                    referencedTable: $$GoalsTableReferences._studentIdTable(db),
                    referencedColumn:
                        $$GoalsTableReferences._studentIdTable(db).id,
                  ) as T;
                }
                if (targetSurahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetSurahId,
                    referencedTable:
                        $$GoalsTableReferences._targetSurahIdTable(db),
                    referencedColumn:
                        $$GoalsTableReferences._targetSurahIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
    (Goal, $$GoalsTableReferences),
    Goal,
    PrefetchHooks Function({bool studentId, bool targetSurahId})>;
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

final class $$MemorizedRangesTableReferences extends BaseReferences<
    _$AppDatabase, $MemorizedRangesTable, MemorizedRange> {
  $$MemorizedRangesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('memorized_ranges__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager($_db, $_db.students)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SurahsTable _surahIdTable(_$AppDatabase db) =>
      db.surahs.createAlias('memorized_ranges__surah_id__surahs__id');

  $$SurahsTableProcessedTableManager get surahId {
    final $_column = $_itemColumn<int>('surah_id')!;

    final manager = $$SurahsTableTableManager($_db, $_db.surahs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

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

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableFilterComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableFilterComposer get surahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableFilterComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableOrderingComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableOrderingComposer get surahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableOrderingComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SurahsTableAnnotationComposer get surahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.surahId,
        referencedTable: $db.surahs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SurahsTableAnnotationComposer(
              $db: $db,
              $table: $db.surahs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (MemorizedRange, $$MemorizedRangesTableReferences),
    MemorizedRange,
    PrefetchHooks Function({bool studentId, bool surahId})> {
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
              .map((e) => (
                    e.readTable(table),
                    $$MemorizedRangesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({studentId = false, surahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (studentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.studentId,
                    referencedTable:
                        $$MemorizedRangesTableReferences._studentIdTable(db),
                    referencedColumn:
                        $$MemorizedRangesTableReferences._studentIdTable(db).id,
                  ) as T;
                }
                if (surahId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.surahId,
                    referencedTable:
                        $$MemorizedRangesTableReferences._surahIdTable(db),
                    referencedColumn:
                        $$MemorizedRangesTableReferences._surahIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
    (MemorizedRange, $$MemorizedRangesTableReferences),
    MemorizedRange,
    PrefetchHooks Function({bool studentId, bool surahId})>;
typedef $$GroupMembersTableCreateCompanionBuilder = GroupMembersCompanion
    Function({
  Value<int> id,
  required int groupId,
  required int studentId,
  Value<DateTime> joinedAt,
});
typedef $$GroupMembersTableUpdateCompanionBuilder = GroupMembersCompanion
    Function({
  Value<int> id,
  Value<int> groupId,
  Value<int> studentId,
  Value<DateTime> joinedAt,
});

final class $$GroupMembersTableReferences
    extends BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMember> {
  $$GroupMembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('group_members__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('group_members__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager($_db, $_db.students)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$GroupMembersTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnFilters(column));

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableFilterComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnOrderings(column));

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableOrderingComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupMembersTable,
    GroupMember,
    $$GroupMembersTableFilterComposer,
    $$GroupMembersTableOrderingComposer,
    $$GroupMembersTableAnnotationComposer,
    $$GroupMembersTableCreateCompanionBuilder,
    $$GroupMembersTableUpdateCompanionBuilder,
    (GroupMember, $$GroupMembersTableReferences),
    GroupMember,
    PrefetchHooks Function({bool groupId, bool studentId})> {
  $$GroupMembersTableTableManager(_$AppDatabase db, $GroupMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<DateTime> joinedAt = const Value.absent(),
          }) =>
              GroupMembersCompanion(
            id: id,
            groupId: groupId,
            studentId: studentId,
            joinedAt: joinedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required int studentId,
            Value<DateTime> joinedAt = const Value.absent(),
          }) =>
              GroupMembersCompanion.insert(
            id: id,
            groupId: groupId,
            studentId: studentId,
            joinedAt: joinedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$GroupMembersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({groupId = false, studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$GroupMembersTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$GroupMembersTableReferences._groupIdTable(db).id,
                  ) as T;
                }
                if (studentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.studentId,
                    referencedTable:
                        $$GroupMembersTableReferences._studentIdTable(db),
                    referencedColumn:
                        $$GroupMembersTableReferences._studentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$GroupMembersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupMembersTable,
    GroupMember,
    $$GroupMembersTableFilterComposer,
    $$GroupMembersTableOrderingComposer,
    $$GroupMembersTableAnnotationComposer,
    $$GroupMembersTableCreateCompanionBuilder,
    $$GroupMembersTableUpdateCompanionBuilder,
    (GroupMember, $$GroupMembersTableReferences),
    GroupMember,
    PrefetchHooks Function({bool groupId, bool studentId})>;
typedef $$GroupScheduleSlotsTableCreateCompanionBuilder
    = GroupScheduleSlotsCompanion Function({
  Value<int> id,
  required int groupId,
  required int weekday,
  required String anchorType,
  Value<String?> fixedTime,
  Value<String?> prayerName,
  Value<int> offsetMinutes,
  required DateTime effectiveFrom,
  Value<DateTime?> effectiveTo,
  Value<DateTime> createdAt,
});
typedef $$GroupScheduleSlotsTableUpdateCompanionBuilder
    = GroupScheduleSlotsCompanion Function({
  Value<int> id,
  Value<int> groupId,
  Value<int> weekday,
  Value<String> anchorType,
  Value<String?> fixedTime,
  Value<String?> prayerName,
  Value<int> offsetMinutes,
  Value<DateTime> effectiveFrom,
  Value<DateTime?> effectiveTo,
  Value<DateTime> createdAt,
});

final class $$GroupScheduleSlotsTableReferences extends BaseReferences<
    _$AppDatabase, $GroupScheduleSlotsTable, GroupScheduleSlot> {
  $$GroupScheduleSlotsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('group_schedule_slots__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ScheduleExceptionsTable,
      List<ScheduleException>> _scheduleExceptionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.scheduleExceptions,
          aliasName:
              'group_schedule_slots__id__schedule_exceptions__group_schedule_slot_id');

  $$ScheduleExceptionsTableProcessedTableManager get scheduleExceptionsRefs {
    final manager =
        $$ScheduleExceptionsTableTableManager($_db, $_db.scheduleExceptions)
            .filter((f) =>
                f.groupScheduleSlotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_scheduleExceptionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GroupScheduleSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupScheduleSlotsTable> {
  $$GroupScheduleSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get anchorType => $composableBuilder(
      column: $table.anchorType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fixedTime => $composableBuilder(
      column: $table.fixedTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prayerName => $composableBuilder(
      column: $table.prayerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get offsetMinutes => $composableBuilder(
      column: $table.offsetMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get effectiveTo => $composableBuilder(
      column: $table.effectiveTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> scheduleExceptionsRefs(
      Expression<bool> Function($$ScheduleExceptionsTableFilterComposer f) f) {
    final $$ScheduleExceptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.scheduleExceptions,
        getReferencedColumn: (t) => t.groupScheduleSlotId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ScheduleExceptionsTableFilterComposer(
              $db: $db,
              $table: $db.scheduleExceptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GroupScheduleSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupScheduleSlotsTable> {
  $$GroupScheduleSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get anchorType => $composableBuilder(
      column: $table.anchorType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fixedTime => $composableBuilder(
      column: $table.fixedTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prayerName => $composableBuilder(
      column: $table.prayerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get offsetMinutes => $composableBuilder(
      column: $table.offsetMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get effectiveTo => $composableBuilder(
      column: $table.effectiveTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupScheduleSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupScheduleSlotsTable> {
  $$GroupScheduleSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get anchorType => $composableBuilder(
      column: $table.anchorType, builder: (column) => column);

  GeneratedColumn<String> get fixedTime =>
      $composableBuilder(column: $table.fixedTime, builder: (column) => column);

  GeneratedColumn<String> get prayerName => $composableBuilder(
      column: $table.prayerName, builder: (column) => column);

  GeneratedColumn<int> get offsetMinutes => $composableBuilder(
      column: $table.offsetMinutes, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveTo => $composableBuilder(
      column: $table.effectiveTo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> scheduleExceptionsRefs<T extends Object>(
      Expression<T> Function($$ScheduleExceptionsTableAnnotationComposer a) f) {
    final $$ScheduleExceptionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.scheduleExceptions,
            getReferencedColumn: (t) => t.groupScheduleSlotId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ScheduleExceptionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.scheduleExceptions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$GroupScheduleSlotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupScheduleSlotsTable,
    GroupScheduleSlot,
    $$GroupScheduleSlotsTableFilterComposer,
    $$GroupScheduleSlotsTableOrderingComposer,
    $$GroupScheduleSlotsTableAnnotationComposer,
    $$GroupScheduleSlotsTableCreateCompanionBuilder,
    $$GroupScheduleSlotsTableUpdateCompanionBuilder,
    (GroupScheduleSlot, $$GroupScheduleSlotsTableReferences),
    GroupScheduleSlot,
    PrefetchHooks Function({bool groupId, bool scheduleExceptionsRefs})> {
  $$GroupScheduleSlotsTableTableManager(
      _$AppDatabase db, $GroupScheduleSlotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupScheduleSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupScheduleSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupScheduleSlotsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<int> weekday = const Value.absent(),
            Value<String> anchorType = const Value.absent(),
            Value<String?> fixedTime = const Value.absent(),
            Value<String?> prayerName = const Value.absent(),
            Value<int> offsetMinutes = const Value.absent(),
            Value<DateTime> effectiveFrom = const Value.absent(),
            Value<DateTime?> effectiveTo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GroupScheduleSlotsCompanion(
            id: id,
            groupId: groupId,
            weekday: weekday,
            anchorType: anchorType,
            fixedTime: fixedTime,
            prayerName: prayerName,
            offsetMinutes: offsetMinutes,
            effectiveFrom: effectiveFrom,
            effectiveTo: effectiveTo,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required int weekday,
            required String anchorType,
            Value<String?> fixedTime = const Value.absent(),
            Value<String?> prayerName = const Value.absent(),
            Value<int> offsetMinutes = const Value.absent(),
            required DateTime effectiveFrom,
            Value<DateTime?> effectiveTo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              GroupScheduleSlotsCompanion.insert(
            id: id,
            groupId: groupId,
            weekday: weekday,
            anchorType: anchorType,
            fixedTime: fixedTime,
            prayerName: prayerName,
            offsetMinutes: offsetMinutes,
            effectiveFrom: effectiveFrom,
            effectiveTo: effectiveTo,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$GroupScheduleSlotsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {groupId = false, scheduleExceptionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (scheduleExceptionsRefs) db.scheduleExceptions
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$GroupScheduleSlotsTableReferences._groupIdTable(db),
                    referencedColumn: $$GroupScheduleSlotsTableReferences
                        ._groupIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scheduleExceptionsRefs)
                    await $_getPrefetchedData<GroupScheduleSlot,
                            $GroupScheduleSlotsTable, ScheduleException>(
                        currentTable: table,
                        referencedTable: $$GroupScheduleSlotsTableReferences
                            ._scheduleExceptionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupScheduleSlotsTableReferences(db, table, p0)
                                .scheduleExceptionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.groupScheduleSlotId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GroupScheduleSlotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupScheduleSlotsTable,
    GroupScheduleSlot,
    $$GroupScheduleSlotsTableFilterComposer,
    $$GroupScheduleSlotsTableOrderingComposer,
    $$GroupScheduleSlotsTableAnnotationComposer,
    $$GroupScheduleSlotsTableCreateCompanionBuilder,
    $$GroupScheduleSlotsTableUpdateCompanionBuilder,
    (GroupScheduleSlot, $$GroupScheduleSlotsTableReferences),
    GroupScheduleSlot,
    PrefetchHooks Function({bool groupId, bool scheduleExceptionsRefs})>;
typedef $$ScheduleExceptionsTableCreateCompanionBuilder
    = ScheduleExceptionsCompanion Function({
  Value<int> id,
  required int groupScheduleSlotId,
  required DateTime occurrenceDate,
  required String exceptionType,
  Value<DateTime?> newDate,
  Value<String?> newTime,
  Value<DateTime> createdAt,
});
typedef $$ScheduleExceptionsTableUpdateCompanionBuilder
    = ScheduleExceptionsCompanion Function({
  Value<int> id,
  Value<int> groupScheduleSlotId,
  Value<DateTime> occurrenceDate,
  Value<String> exceptionType,
  Value<DateTime?> newDate,
  Value<String?> newTime,
  Value<DateTime> createdAt,
});

final class $$ScheduleExceptionsTableReferences extends BaseReferences<
    _$AppDatabase, $ScheduleExceptionsTable, ScheduleException> {
  $$ScheduleExceptionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $GroupScheduleSlotsTable _groupScheduleSlotIdTable(_$AppDatabase db) =>
      db.groupScheduleSlots.createAlias(
          'schedule_exceptions__group_schedule_slot_id__group_schedule_slots__id');

  $$GroupScheduleSlotsTableProcessedTableManager get groupScheduleSlotId {
    final $_column = $_itemColumn<int>('group_schedule_slot_id')!;

    final manager =
        $$GroupScheduleSlotsTableTableManager($_db, $_db.groupScheduleSlots)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupScheduleSlotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ScheduleExceptionsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleExceptionsTable> {
  $$ScheduleExceptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurrenceDate => $composableBuilder(
      column: $table.occurrenceDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exceptionType => $composableBuilder(
      column: $table.exceptionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get newDate => $composableBuilder(
      column: $table.newDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get newTime => $composableBuilder(
      column: $table.newTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$GroupScheduleSlotsTableFilterComposer get groupScheduleSlotId {
    final $$GroupScheduleSlotsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupScheduleSlotId,
        referencedTable: $db.groupScheduleSlots,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupScheduleSlotsTableFilterComposer(
              $db: $db,
              $table: $db.groupScheduleSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ScheduleExceptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleExceptionsTable> {
  $$ScheduleExceptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurrenceDate => $composableBuilder(
      column: $table.occurrenceDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exceptionType => $composableBuilder(
      column: $table.exceptionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get newDate => $composableBuilder(
      column: $table.newDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get newTime => $composableBuilder(
      column: $table.newTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$GroupScheduleSlotsTableOrderingComposer get groupScheduleSlotId {
    final $$GroupScheduleSlotsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupScheduleSlotId,
        referencedTable: $db.groupScheduleSlots,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupScheduleSlotsTableOrderingComposer(
              $db: $db,
              $table: $db.groupScheduleSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ScheduleExceptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleExceptionsTable> {
  $$ScheduleExceptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurrenceDate => $composableBuilder(
      column: $table.occurrenceDate, builder: (column) => column);

  GeneratedColumn<String> get exceptionType => $composableBuilder(
      column: $table.exceptionType, builder: (column) => column);

  GeneratedColumn<DateTime> get newDate =>
      $composableBuilder(column: $table.newDate, builder: (column) => column);

  GeneratedColumn<String> get newTime =>
      $composableBuilder(column: $table.newTime, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GroupScheduleSlotsTableAnnotationComposer get groupScheduleSlotId {
    final $$GroupScheduleSlotsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.groupScheduleSlotId,
            referencedTable: $db.groupScheduleSlots,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GroupScheduleSlotsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.groupScheduleSlots,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ScheduleExceptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduleExceptionsTable,
    ScheduleException,
    $$ScheduleExceptionsTableFilterComposer,
    $$ScheduleExceptionsTableOrderingComposer,
    $$ScheduleExceptionsTableAnnotationComposer,
    $$ScheduleExceptionsTableCreateCompanionBuilder,
    $$ScheduleExceptionsTableUpdateCompanionBuilder,
    (ScheduleException, $$ScheduleExceptionsTableReferences),
    ScheduleException,
    PrefetchHooks Function({bool groupScheduleSlotId})> {
  $$ScheduleExceptionsTableTableManager(
      _$AppDatabase db, $ScheduleExceptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleExceptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleExceptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleExceptionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupScheduleSlotId = const Value.absent(),
            Value<DateTime> occurrenceDate = const Value.absent(),
            Value<String> exceptionType = const Value.absent(),
            Value<DateTime?> newDate = const Value.absent(),
            Value<String?> newTime = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ScheduleExceptionsCompanion(
            id: id,
            groupScheduleSlotId: groupScheduleSlotId,
            occurrenceDate: occurrenceDate,
            exceptionType: exceptionType,
            newDate: newDate,
            newTime: newTime,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupScheduleSlotId,
            required DateTime occurrenceDate,
            required String exceptionType,
            Value<DateTime?> newDate = const Value.absent(),
            Value<String?> newTime = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ScheduleExceptionsCompanion.insert(
            id: id,
            groupScheduleSlotId: groupScheduleSlotId,
            occurrenceDate: occurrenceDate,
            exceptionType: exceptionType,
            newDate: newDate,
            newTime: newTime,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ScheduleExceptionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({groupScheduleSlotId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (groupScheduleSlotId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupScheduleSlotId,
                    referencedTable: $$ScheduleExceptionsTableReferences
                        ._groupScheduleSlotIdTable(db),
                    referencedColumn: $$ScheduleExceptionsTableReferences
                        ._groupScheduleSlotIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ScheduleExceptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScheduleExceptionsTable,
    ScheduleException,
    $$ScheduleExceptionsTableFilterComposer,
    $$ScheduleExceptionsTableOrderingComposer,
    $$ScheduleExceptionsTableAnnotationComposer,
    $$ScheduleExceptionsTableCreateCompanionBuilder,
    $$ScheduleExceptionsTableUpdateCompanionBuilder,
    (ScheduleException, $$ScheduleExceptionsTableReferences),
    ScheduleException,
    PrefetchHooks Function({bool groupScheduleSlotId})>;
typedef $$JuzQuarterProgressTableCreateCompanionBuilder
    = JuzQuarterProgressCompanion Function({
  Value<int> id,
  required int studentId,
  required int juzNumber,
  required int quarterIndex,
  Value<DateTime> completedAt,
});
typedef $$JuzQuarterProgressTableUpdateCompanionBuilder
    = JuzQuarterProgressCompanion Function({
  Value<int> id,
  Value<int> studentId,
  Value<int> juzNumber,
  Value<int> quarterIndex,
  Value<DateTime> completedAt,
});

final class $$JuzQuarterProgressTableReferences extends BaseReferences<
    _$AppDatabase, $JuzQuarterProgressTable, JuzQuarterProgressData> {
  $$JuzQuarterProgressTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('juz_quarter_progress__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager($_db, $_db.students)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$JuzQuarterProgressTableFilterComposer
    extends Composer<_$AppDatabase, $JuzQuarterProgressTable> {
  $$JuzQuarterProgressTableFilterComposer({
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

  ColumnFilters<int> get quarterIndex => $composableBuilder(
      column: $table.quarterIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableFilterComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JuzQuarterProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $JuzQuarterProgressTable> {
  $$JuzQuarterProgressTableOrderingComposer({
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

  ColumnOrderings<int> get quarterIndex => $composableBuilder(
      column: $table.quarterIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableOrderingComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JuzQuarterProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $JuzQuarterProgressTable> {
  $$JuzQuarterProgressTableAnnotationComposer({
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

  GeneratedColumn<int> get quarterIndex => $composableBuilder(
      column: $table.quarterIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JuzQuarterProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JuzQuarterProgressTable,
    JuzQuarterProgressData,
    $$JuzQuarterProgressTableFilterComposer,
    $$JuzQuarterProgressTableOrderingComposer,
    $$JuzQuarterProgressTableAnnotationComposer,
    $$JuzQuarterProgressTableCreateCompanionBuilder,
    $$JuzQuarterProgressTableUpdateCompanionBuilder,
    (JuzQuarterProgressData, $$JuzQuarterProgressTableReferences),
    JuzQuarterProgressData,
    PrefetchHooks Function({bool studentId})> {
  $$JuzQuarterProgressTableTableManager(
      _$AppDatabase db, $JuzQuarterProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JuzQuarterProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JuzQuarterProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JuzQuarterProgressTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<int> juzNumber = const Value.absent(),
            Value<int> quarterIndex = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
          }) =>
              JuzQuarterProgressCompanion(
            id: id,
            studentId: studentId,
            juzNumber: juzNumber,
            quarterIndex: quarterIndex,
            completedAt: completedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int studentId,
            required int juzNumber,
            required int quarterIndex,
            Value<DateTime> completedAt = const Value.absent(),
          }) =>
              JuzQuarterProgressCompanion.insert(
            id: id,
            studentId: studentId,
            juzNumber: juzNumber,
            quarterIndex: quarterIndex,
            completedAt: completedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$JuzQuarterProgressTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (studentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.studentId,
                    referencedTable:
                        $$JuzQuarterProgressTableReferences._studentIdTable(db),
                    referencedColumn: $$JuzQuarterProgressTableReferences
                        ._studentIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$JuzQuarterProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JuzQuarterProgressTable,
    JuzQuarterProgressData,
    $$JuzQuarterProgressTableFilterComposer,
    $$JuzQuarterProgressTableOrderingComposer,
    $$JuzQuarterProgressTableAnnotationComposer,
    $$JuzQuarterProgressTableCreateCompanionBuilder,
    $$JuzQuarterProgressTableUpdateCompanionBuilder,
    (JuzQuarterProgressData, $$JuzQuarterProgressTableReferences),
    JuzQuarterProgressData,
    PrefetchHooks Function({bool studentId})>;

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
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SessionMemorizationsTableTableManager get sessionMemorizations =>
      $$SessionMemorizationsTableTableManager(_db, _db.sessionMemorizations);
  $$SessionRevisionsTableTableManager get sessionRevisions =>
      $$SessionRevisionsTableTableManager(_db, _db.sessionRevisions);
  $$SessionEvaluationsTableTableManager get sessionEvaluations =>
      $$SessionEvaluationsTableTableManager(_db, _db.sessionEvaluations);
  $$SessionAttendancesTableTableManager get sessionAttendances =>
      $$SessionAttendancesTableTableManager(_db, _db.sessionAttendances);
  $$SchedulesTableTableManager get schedules =>
      $$SchedulesTableTableManager(_db, _db.schedules);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$MemorizedRangesTableTableManager get memorizedRanges =>
      $$MemorizedRangesTableTableManager(_db, _db.memorizedRanges);
  $$GroupMembersTableTableManager get groupMembers =>
      $$GroupMembersTableTableManager(_db, _db.groupMembers);
  $$GroupScheduleSlotsTableTableManager get groupScheduleSlots =>
      $$GroupScheduleSlotsTableTableManager(_db, _db.groupScheduleSlots);
  $$ScheduleExceptionsTableTableManager get scheduleExceptions =>
      $$ScheduleExceptionsTableTableManager(_db, _db.scheduleExceptions);
  $$JuzQuarterProgressTableTableManager get juzQuarterProgress =>
      $$JuzQuarterProgressTableTableManager(_db, _db.juzQuarterProgress);
}
