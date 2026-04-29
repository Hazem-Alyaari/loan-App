// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  phoneNormalized: json['phoneNormalized'] as String?,
  authProvider: $enumDecode(_$AuthProviderEnumMap, json['authProvider']),
  providerId: json['providerId'] as String?,
  mustChangePassword: json['mustChangePassword'] as bool? ?? false,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'phoneNormalized': instance.phoneNormalized,
  'authProvider': _$AuthProviderEnumMap[instance.authProvider]!,
  'providerId': instance.providerId,
  'mustChangePassword': instance.mustChangePassword,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
};

const _$AuthProviderEnumMap = {
  AuthProvider.email: 'email',
  AuthProvider.google: 'google',
  AuthProvider.apple: 'apple',
};
