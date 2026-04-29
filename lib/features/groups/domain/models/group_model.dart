import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan/core/utils/timestamp_converter.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
abstract class GroupModel with _$GroupModel {
  const factory GroupModel({
    required String id,
    required String name,
    required String createdByUserId,
    @TimestampConverter() required DateTime createdAt,
    @Default(false) bool isArchived,
    @Default('USD') String currencyCode,
    @Default([]) List<String> memberIds,
    @Default({}) Map<String, double> balances,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return GroupModel.fromJson({'id': doc.id, ...data});
  }
}
