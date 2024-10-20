// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_contract_abi_output_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SmartContractAbiOutputDto _$SmartContractAbiOutputDtoFromJson(
    Map<String, dynamic> json) {
  return _SmartContractAbiOutputDto.fromJson(json);
}

/// @nodoc
mixin _$SmartContractAbiOutputDto {
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get internalType => throw _privateConstructorUsedError;

  /// Serializes this SmartContractAbiOutputDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartContractAbiOutputDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartContractAbiOutputDtoCopyWith<SmartContractAbiOutputDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartContractAbiOutputDtoCopyWith<$Res> {
  factory $SmartContractAbiOutputDtoCopyWith(SmartContractAbiOutputDto value,
          $Res Function(SmartContractAbiOutputDto) then) =
      _$SmartContractAbiOutputDtoCopyWithImpl<$Res, SmartContractAbiOutputDto>;
  @useResult
  $Res call({String name, String type, String internalType});
}

/// @nodoc
class _$SmartContractAbiOutputDtoCopyWithImpl<$Res,
        $Val extends SmartContractAbiOutputDto>
    implements $SmartContractAbiOutputDtoCopyWith<$Res> {
  _$SmartContractAbiOutputDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartContractAbiOutputDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? internalType = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      internalType: null == internalType
          ? _value.internalType
          : internalType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmartContractAbiOutputDtoImplCopyWith<$Res>
    implements $SmartContractAbiOutputDtoCopyWith<$Res> {
  factory _$$SmartContractAbiOutputDtoImplCopyWith(
          _$SmartContractAbiOutputDtoImpl value,
          $Res Function(_$SmartContractAbiOutputDtoImpl) then) =
      __$$SmartContractAbiOutputDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String type, String internalType});
}

/// @nodoc
class __$$SmartContractAbiOutputDtoImplCopyWithImpl<$Res>
    extends _$SmartContractAbiOutputDtoCopyWithImpl<$Res,
        _$SmartContractAbiOutputDtoImpl>
    implements _$$SmartContractAbiOutputDtoImplCopyWith<$Res> {
  __$$SmartContractAbiOutputDtoImplCopyWithImpl(
      _$SmartContractAbiOutputDtoImpl _value,
      $Res Function(_$SmartContractAbiOutputDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SmartContractAbiOutputDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? internalType = null,
  }) {
    return _then(_$SmartContractAbiOutputDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      internalType: null == internalType
          ? _value.internalType
          : internalType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SmartContractAbiOutputDtoImpl implements _SmartContractAbiOutputDto {
  _$SmartContractAbiOutputDtoImpl(
      {this.name = "", required this.type, this.internalType = ""});

  factory _$SmartContractAbiOutputDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartContractAbiOutputDtoImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  final String type;
  @override
  @JsonKey()
  final String internalType;

  @override
  String toString() {
    return 'SmartContractAbiOutputDto(name: $name, type: $type, internalType: $internalType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartContractAbiOutputDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.internalType, internalType) ||
                other.internalType == internalType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, type, internalType);

  /// Create a copy of SmartContractAbiOutputDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartContractAbiOutputDtoImplCopyWith<_$SmartContractAbiOutputDtoImpl>
      get copyWith => __$$SmartContractAbiOutputDtoImplCopyWithImpl<
          _$SmartContractAbiOutputDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartContractAbiOutputDtoImplToJson(
      this,
    );
  }
}

abstract class _SmartContractAbiOutputDto implements SmartContractAbiOutputDto {
  factory _SmartContractAbiOutputDto(
      {final String name,
      required final String type,
      final String internalType}) = _$SmartContractAbiOutputDtoImpl;

  factory _SmartContractAbiOutputDto.fromJson(Map<String, dynamic> json) =
      _$SmartContractAbiOutputDtoImpl.fromJson;

  @override
  String get name;
  @override
  String get type;
  @override
  String get internalType;

  /// Create a copy of SmartContractAbiOutputDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartContractAbiOutputDtoImplCopyWith<_$SmartContractAbiOutputDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
