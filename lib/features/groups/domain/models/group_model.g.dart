// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => _GroupModel(
  id: json['id'] as String,
  name: json['name'] as String,
  createdByUserId: json['createdByUserId'] as String,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  isArchived: json['isArchived'] as bool? ?? false,
  currencyCode: json['currencyCode'] as String? ?? 'USD',
  memberIds:
      (json['memberIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  balances:
      (json['balances'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
);

Map<String, dynamic> _$GroupModelToJson(_GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdByUserId': instance.createdByUserId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'isArchived': instance.isArchived,
      'currencyCode': instance.currencyCode,
      'memberIds': instance.memberIds,
      'balances': instance.balances,
    };
