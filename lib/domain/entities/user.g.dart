// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username'] as String,
      passwordHash: json['passwordHash'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String? ?? 'Teacher',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'passwordHash': instance.passwordHash,
      'fullName': instance.fullName,
      'role': instance.role,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
