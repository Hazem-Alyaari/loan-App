// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_approval.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionApproval {

 String get id; String get transactionId; String get userId; ApprovalStatus get status;@NullableTimestampConverter() DateTime? get respondedAt; String get comment;
/// Create a copy of TransactionApproval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionApprovalCopyWith<TransactionApproval> get copyWith => _$TransactionApprovalCopyWithImpl<TransactionApproval>(this as TransactionApproval, _$identity);

  /// Serializes this TransactionApproval to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionApproval&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionId,userId,status,respondedAt,comment);

@override
String toString() {
  return 'TransactionApproval(id: $id, transactionId: $transactionId, userId: $userId, status: $status, respondedAt: $respondedAt, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $TransactionApprovalCopyWith<$Res>  {
  factory $TransactionApprovalCopyWith(TransactionApproval value, $Res Function(TransactionApproval) _then) = _$TransactionApprovalCopyWithImpl;
@useResult
$Res call({
 String id, String transactionId, String userId, ApprovalStatus status,@NullableTimestampConverter() DateTime? respondedAt, String comment
});




}
/// @nodoc
class _$TransactionApprovalCopyWithImpl<$Res>
    implements $TransactionApprovalCopyWith<$Res> {
  _$TransactionApprovalCopyWithImpl(this._self, this._then);

  final TransactionApproval _self;
  final $Res Function(TransactionApproval) _then;

/// Create a copy of TransactionApproval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transactionId = null,Object? userId = null,Object? status = null,Object? respondedAt = freezed,Object? comment = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApprovalStatus,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionApproval].
extension TransactionApprovalPatterns on TransactionApproval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionApproval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionApproval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionApproval value)  $default,){
final _that = this;
switch (_that) {
case _TransactionApproval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionApproval value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionApproval() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String transactionId,  String userId,  ApprovalStatus status, @NullableTimestampConverter()  DateTime? respondedAt,  String comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionApproval() when $default != null:
return $default(_that.id,_that.transactionId,_that.userId,_that.status,_that.respondedAt,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String transactionId,  String userId,  ApprovalStatus status, @NullableTimestampConverter()  DateTime? respondedAt,  String comment)  $default,) {final _that = this;
switch (_that) {
case _TransactionApproval():
return $default(_that.id,_that.transactionId,_that.userId,_that.status,_that.respondedAt,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String transactionId,  String userId,  ApprovalStatus status, @NullableTimestampConverter()  DateTime? respondedAt,  String comment)?  $default,) {final _that = this;
switch (_that) {
case _TransactionApproval() when $default != null:
return $default(_that.id,_that.transactionId,_that.userId,_that.status,_that.respondedAt,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionApproval implements TransactionApproval {
  const _TransactionApproval({required this.id, required this.transactionId, required this.userId, this.status = ApprovalStatus.pending, @NullableTimestampConverter() this.respondedAt, this.comment = ''});
  factory _TransactionApproval.fromJson(Map<String, dynamic> json) => _$TransactionApprovalFromJson(json);

@override final  String id;
@override final  String transactionId;
@override final  String userId;
@override@JsonKey() final  ApprovalStatus status;
@override@NullableTimestampConverter() final  DateTime? respondedAt;
@override@JsonKey() final  String comment;

/// Create a copy of TransactionApproval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionApprovalCopyWith<_TransactionApproval> get copyWith => __$TransactionApprovalCopyWithImpl<_TransactionApproval>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionApprovalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionApproval&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionId,userId,status,respondedAt,comment);

@override
String toString() {
  return 'TransactionApproval(id: $id, transactionId: $transactionId, userId: $userId, status: $status, respondedAt: $respondedAt, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$TransactionApprovalCopyWith<$Res> implements $TransactionApprovalCopyWith<$Res> {
  factory _$TransactionApprovalCopyWith(_TransactionApproval value, $Res Function(_TransactionApproval) _then) = __$TransactionApprovalCopyWithImpl;
@override @useResult
$Res call({
 String id, String transactionId, String userId, ApprovalStatus status,@NullableTimestampConverter() DateTime? respondedAt, String comment
});




}
/// @nodoc
class __$TransactionApprovalCopyWithImpl<$Res>
    implements _$TransactionApprovalCopyWith<$Res> {
  __$TransactionApprovalCopyWithImpl(this._self, this._then);

  final _TransactionApproval _self;
  final $Res Function(_TransactionApproval) _then;

/// Create a copy of TransactionApproval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transactionId = null,Object? userId = null,Object? status = null,Object? respondedAt = freezed,Object? comment = null,}) {
  return _then(_TransactionApproval(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApprovalStatus,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
