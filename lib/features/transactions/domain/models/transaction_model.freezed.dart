// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {

 String get id; String get groupId; String get createdByUserId; TransactionType get type; TransactionStatus get status; String get creditorUserId; String get debtorUserId; double get amount; String get currency; String get note;@TimestampConverter() DateTime get createdAt;@NullableTimestampConverter() DateTime? get approvedAt;@NullableTimestampConverter() DateTime? get rejectedAt;/// Denormalized names for display
 String? get creditorName; String? get debtorName; String? get createdByName;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.creditorUserId, creditorUserId) || other.creditorUserId == creditorUserId)&&(identical(other.debtorUserId, debtorUserId) || other.debtorUserId == debtorUserId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.creditorName, creditorName) || other.creditorName == creditorName)&&(identical(other.debtorName, debtorName) || other.debtorName == debtorName)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,createdByUserId,type,status,creditorUserId,debtorUserId,amount,currency,note,createdAt,approvedAt,rejectedAt,creditorName,debtorName,createdByName);

@override
String toString() {
  return 'TransactionModel(id: $id, groupId: $groupId, createdByUserId: $createdByUserId, type: $type, status: $status, creditorUserId: $creditorUserId, debtorUserId: $debtorUserId, amount: $amount, currency: $currency, note: $note, createdAt: $createdAt, approvedAt: $approvedAt, rejectedAt: $rejectedAt, creditorName: $creditorName, debtorName: $debtorName, createdByName: $createdByName)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String createdByUserId, TransactionType type, TransactionStatus status, String creditorUserId, String debtorUserId, double amount, String currency, String note,@TimestampConverter() DateTime createdAt,@NullableTimestampConverter() DateTime? approvedAt,@NullableTimestampConverter() DateTime? rejectedAt, String? creditorName, String? debtorName, String? createdByName
});




}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? createdByUserId = null,Object? type = null,Object? status = null,Object? creditorUserId = null,Object? debtorUserId = null,Object? amount = null,Object? currency = null,Object? note = null,Object? createdAt = null,Object? approvedAt = freezed,Object? rejectedAt = freezed,Object? creditorName = freezed,Object? debtorName = freezed,Object? createdByName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,creditorUserId: null == creditorUserId ? _self.creditorUserId : creditorUserId // ignore: cast_nullable_to_non_nullable
as String,debtorUserId: null == debtorUserId ? _self.debtorUserId : debtorUserId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,creditorName: freezed == creditorName ? _self.creditorName : creditorName // ignore: cast_nullable_to_non_nullable
as String?,debtorName: freezed == debtorName ? _self.debtorName : debtorName // ignore: cast_nullable_to_non_nullable
as String?,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String createdByUserId,  TransactionType type,  TransactionStatus status,  String creditorUserId,  String debtorUserId,  double amount,  String currency,  String note, @TimestampConverter()  DateTime createdAt, @NullableTimestampConverter()  DateTime? approvedAt, @NullableTimestampConverter()  DateTime? rejectedAt,  String? creditorName,  String? debtorName,  String? createdByName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.groupId,_that.createdByUserId,_that.type,_that.status,_that.creditorUserId,_that.debtorUserId,_that.amount,_that.currency,_that.note,_that.createdAt,_that.approvedAt,_that.rejectedAt,_that.creditorName,_that.debtorName,_that.createdByName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String createdByUserId,  TransactionType type,  TransactionStatus status,  String creditorUserId,  String debtorUserId,  double amount,  String currency,  String note, @TimestampConverter()  DateTime createdAt, @NullableTimestampConverter()  DateTime? approvedAt, @NullableTimestampConverter()  DateTime? rejectedAt,  String? creditorName,  String? debtorName,  String? createdByName)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.id,_that.groupId,_that.createdByUserId,_that.type,_that.status,_that.creditorUserId,_that.debtorUserId,_that.amount,_that.currency,_that.note,_that.createdAt,_that.approvedAt,_that.rejectedAt,_that.creditorName,_that.debtorName,_that.createdByName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String createdByUserId,  TransactionType type,  TransactionStatus status,  String creditorUserId,  String debtorUserId,  double amount,  String currency,  String note, @TimestampConverter()  DateTime createdAt, @NullableTimestampConverter()  DateTime? approvedAt, @NullableTimestampConverter()  DateTime? rejectedAt,  String? creditorName,  String? debtorName,  String? createdByName)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.groupId,_that.createdByUserId,_that.type,_that.status,_that.creditorUserId,_that.debtorUserId,_that.amount,_that.currency,_that.note,_that.createdAt,_that.approvedAt,_that.rejectedAt,_that.creditorName,_that.debtorName,_that.createdByName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel implements TransactionModel {
  const _TransactionModel({required this.id, required this.groupId, required this.createdByUserId, required this.type, this.status = TransactionStatus.pending, required this.creditorUserId, required this.debtorUserId, required this.amount, required this.currency, this.note = '', @TimestampConverter() required this.createdAt, @NullableTimestampConverter() this.approvedAt, @NullableTimestampConverter() this.rejectedAt, this.creditorName, this.debtorName, this.createdByName});
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  String createdByUserId;
@override final  TransactionType type;
@override@JsonKey() final  TransactionStatus status;
@override final  String creditorUserId;
@override final  String debtorUserId;
@override final  double amount;
@override final  String currency;
@override@JsonKey() final  String note;
@override@TimestampConverter() final  DateTime createdAt;
@override@NullableTimestampConverter() final  DateTime? approvedAt;
@override@NullableTimestampConverter() final  DateTime? rejectedAt;
/// Denormalized names for display
@override final  String? creditorName;
@override final  String? debtorName;
@override final  String? createdByName;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.creditorUserId, creditorUserId) || other.creditorUserId == creditorUserId)&&(identical(other.debtorUserId, debtorUserId) || other.debtorUserId == debtorUserId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.creditorName, creditorName) || other.creditorName == creditorName)&&(identical(other.debtorName, debtorName) || other.debtorName == debtorName)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,createdByUserId,type,status,creditorUserId,debtorUserId,amount,currency,note,createdAt,approvedAt,rejectedAt,creditorName,debtorName,createdByName);

@override
String toString() {
  return 'TransactionModel(id: $id, groupId: $groupId, createdByUserId: $createdByUserId, type: $type, status: $status, creditorUserId: $creditorUserId, debtorUserId: $debtorUserId, amount: $amount, currency: $currency, note: $note, createdAt: $createdAt, approvedAt: $approvedAt, rejectedAt: $rejectedAt, creditorName: $creditorName, debtorName: $debtorName, createdByName: $createdByName)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String createdByUserId, TransactionType type, TransactionStatus status, String creditorUserId, String debtorUserId, double amount, String currency, String note,@TimestampConverter() DateTime createdAt,@NullableTimestampConverter() DateTime? approvedAt,@NullableTimestampConverter() DateTime? rejectedAt, String? creditorName, String? debtorName, String? createdByName
});




}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? createdByUserId = null,Object? type = null,Object? status = null,Object? creditorUserId = null,Object? debtorUserId = null,Object? amount = null,Object? currency = null,Object? note = null,Object? createdAt = null,Object? approvedAt = freezed,Object? rejectedAt = freezed,Object? creditorName = freezed,Object? debtorName = freezed,Object? createdByName = freezed,}) {
  return _then(_TransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,creditorUserId: null == creditorUserId ? _self.creditorUserId : creditorUserId // ignore: cast_nullable_to_non_nullable
as String,debtorUserId: null == debtorUserId ? _self.debtorUserId : debtorUserId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,creditorName: freezed == creditorName ? _self.creditorName : creditorName // ignore: cast_nullable_to_non_nullable
as String?,debtorName: freezed == debtorName ? _self.debtorName : debtorName // ignore: cast_nullable_to_non_nullable
as String?,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
