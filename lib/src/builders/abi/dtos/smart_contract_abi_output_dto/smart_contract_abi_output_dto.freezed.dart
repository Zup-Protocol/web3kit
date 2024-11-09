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

SmartContractAbiSignatureDto _$SmartContractAbiSignatureDtoFromJson(
    Map<String, dynamic> json) {
  return _SmartContractAbiSignatureDto.fromJson(json);
}

/// @nodoc
mixin _$SmartContractAbiSignatureDto {
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get internalType => throw _privateConstructorUsedError;

  /// Serializes this SmartContractAbiSignatureDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartContractAbiSignatureDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartContractAbiSignatureDtoCopyWith<SmartContractAbiSignatureDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartContractAbiSignatureDtoCopyWith<$Res> {
  factory $SmartContractAbiSignatureDtoCopyWith(
          SmartContractAbiSignatureDto value,
          $Res Function(SmartContractAbiSignatureDto) then) =
      _$SmartContractAbiSignatureDtoCopyWithImpl<$Res,
          SmartContractAbiSignatureDto>;
  @useResult
  $Res call({String name, String type, String internalType});
}

/// @nodoc
class _$SmartContractAbiSignatureDtoCopyWithImpl<$Res,
        $Val extends SmartContractAbiSignatureDto>
    implements $SmartContractAbiSignatureDtoCopyWith<$Res> {
  _$SmartContractAbiSignatureDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartContractAbiSignatureDto
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
abstract class _$$SmartContractAbiSignatureDtoImplCopyWith<$Res>
    implements $SmartContractAbiSignatureDtoCopyWith<$Res> {
  factory _$$SmartContractAbiSignatureDtoImplCopyWith(
          _$SmartContractAbiSignatureDtoImpl value,
          $Res Function(_$SmartContractAbiSignatureDtoImpl) then) =
      __$$SmartContractAbiSignatureDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String type, String internalType});
}

/// @nodoc
class __$$SmartContractAbiSignatureDtoImplCopyWithImpl<$Res>
    extends _$SmartContractAbiSignatureDtoCopyWithImpl<$Res,
        _$SmartContractAbiSignatureDtoImpl>
    implements _$$SmartContractAbiSignatureDtoImplCopyWith<$Res> {
  __$$SmartContractAbiSignatureDtoImplCopyWithImpl(
      _$SmartContractAbiSignatureDtoImpl _value,
      $Res Function(_$SmartContractAbiSignatureDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SmartContractAbiSignatureDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? internalType = null,
  }) {
    return _then(_$SmartContractAbiSignatureDtoImpl(
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
class _$SmartContractAbiSignatureDtoImpl
    implements _SmartContractAbiSignatureDto {
  _$SmartContractAbiSignatureDtoImpl(
      {this.name = "", required this.type, this.internalType = ""});

  factory _$SmartContractAbiSignatureDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SmartContractAbiSignatureDtoImplFromJson(json);

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
    return 'SmartContractAbiSignatureDto(name: $name, type: $type, internalType: $internalType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartContractAbiSignatureDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.internalType, internalType) ||
                other.internalType == internalType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, type, internalType);

  /// Create a copy of SmartContractAbiSignatureDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartContractAbiSignatureDtoImplCopyWith<
          _$SmartContractAbiSignatureDtoImpl>
      get copyWith => __$$SmartContractAbiSignatureDtoImplCopyWithImpl<
          _$SmartContractAbiSignatureDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartContractAbiSignatureDtoImplToJson(
      this,
    );
  }
}

abstract class _SmartContractAbiSignatureDto
    implements SmartContractAbiSignatureDto {
  factory _SmartContractAbiSignatureDto(
      {final String name,
      required final String type,
      final String internalType}) = _$SmartContractAbiSignatureDtoImpl;

  factory _SmartContractAbiSignatureDto.fromJson(Map<String, dynamic> json) =
      _$SmartContractAbiSignatureDtoImpl.fromJson;

  @override
  String get name;
  @override
  String get type;
  @override
  String get internalType;

  /// Create a copy of SmartContractAbiSignatureDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartContractAbiSignatureDtoImplCopyWith<
          _$SmartContractAbiSignatureDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
