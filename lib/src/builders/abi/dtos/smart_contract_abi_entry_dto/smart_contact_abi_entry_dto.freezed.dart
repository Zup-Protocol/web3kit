// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_contact_abi_entry_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SmartContractAbiEntryDto _$SmartContractAbiEntryDtoFromJson(
    Map<String, dynamic> json) {
  return _SmartContractAbiEntryDto.fromJson(json);
}

/// @nodoc
mixin _$SmartContractAbiEntryDto {
  @JsonKey(unknownEnumValue: SmartContractAbiEntryType.unknown)
  SmartContractAbiEntryType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: SmartContractStateMutability.unknown)
  SmartContractStateMutability get stateMutability =>
      throw _privateConstructorUsedError;
  List<SmartContractAbiSignatureDto> get outputs =>
      throw _privateConstructorUsedError;
  List<SmartContractAbiSignatureDto> get inputs =>
      throw _privateConstructorUsedError;

  /// Serializes this SmartContractAbiEntryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartContractAbiEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartContractAbiEntryDtoCopyWith<SmartContractAbiEntryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartContractAbiEntryDtoCopyWith<$Res> {
  factory $SmartContractAbiEntryDtoCopyWith(SmartContractAbiEntryDto value,
          $Res Function(SmartContractAbiEntryDto) then) =
      _$SmartContractAbiEntryDtoCopyWithImpl<$Res, SmartContractAbiEntryDto>;
  @useResult
  $Res call(
      {@JsonKey(unknownEnumValue: SmartContractAbiEntryType.unknown)
      SmartContractAbiEntryType type,
      String name,
      @JsonKey(unknownEnumValue: SmartContractStateMutability.unknown)
      SmartContractStateMutability stateMutability,
      List<SmartContractAbiSignatureDto> outputs,
      List<SmartContractAbiSignatureDto> inputs});
}

/// @nodoc
class _$SmartContractAbiEntryDtoCopyWithImpl<$Res,
        $Val extends SmartContractAbiEntryDto>
    implements $SmartContractAbiEntryDtoCopyWith<$Res> {
  _$SmartContractAbiEntryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartContractAbiEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? stateMutability = null,
    Object? outputs = null,
    Object? inputs = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SmartContractAbiEntryType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stateMutability: null == stateMutability
          ? _value.stateMutability
          : stateMutability // ignore: cast_nullable_to_non_nullable
              as SmartContractStateMutability,
      outputs: null == outputs
          ? _value.outputs
          : outputs // ignore: cast_nullable_to_non_nullable
              as List<SmartContractAbiSignatureDto>,
      inputs: null == inputs
          ? _value.inputs
          : inputs // ignore: cast_nullable_to_non_nullable
              as List<SmartContractAbiSignatureDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmartContractAbiEntryDtoImplCopyWith<$Res>
    implements $SmartContractAbiEntryDtoCopyWith<$Res> {
  factory _$$SmartContractAbiEntryDtoImplCopyWith(
          _$SmartContractAbiEntryDtoImpl value,
          $Res Function(_$SmartContractAbiEntryDtoImpl) then) =
      __$$SmartContractAbiEntryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(unknownEnumValue: SmartContractAbiEntryType.unknown)
      SmartContractAbiEntryType type,
      String name,
      @JsonKey(unknownEnumValue: SmartContractStateMutability.unknown)
      SmartContractStateMutability stateMutability,
      List<SmartContractAbiSignatureDto> outputs,
      List<SmartContractAbiSignatureDto> inputs});
}

/// @nodoc
class __$$SmartContractAbiEntryDtoImplCopyWithImpl<$Res>
    extends _$SmartContractAbiEntryDtoCopyWithImpl<$Res,
        _$SmartContractAbiEntryDtoImpl>
    implements _$$SmartContractAbiEntryDtoImplCopyWith<$Res> {
  __$$SmartContractAbiEntryDtoImplCopyWithImpl(
      _$SmartContractAbiEntryDtoImpl _value,
      $Res Function(_$SmartContractAbiEntryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SmartContractAbiEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? stateMutability = null,
    Object? outputs = null,
    Object? inputs = null,
  }) {
    return _then(_$SmartContractAbiEntryDtoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SmartContractAbiEntryType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stateMutability: null == stateMutability
          ? _value.stateMutability
          : stateMutability // ignore: cast_nullable_to_non_nullable
              as SmartContractStateMutability,
      outputs: null == outputs
          ? _value._outputs
          : outputs // ignore: cast_nullable_to_non_nullable
              as List<SmartContractAbiSignatureDto>,
      inputs: null == inputs
          ? _value._inputs
          : inputs // ignore: cast_nullable_to_non_nullable
              as List<SmartContractAbiSignatureDto>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SmartContractAbiEntryDtoImpl extends _SmartContractAbiEntryDto {
  _$SmartContractAbiEntryDtoImpl(
      {@JsonKey(unknownEnumValue: SmartContractAbiEntryType.unknown)
      this.type = SmartContractAbiEntryType.unknown,
      this.name = "",
      @JsonKey(unknownEnumValue: SmartContractStateMutability.unknown)
      this.stateMutability = SmartContractStateMutability.unknown,
      final List<SmartContractAbiSignatureDto> outputs =
          const <SmartContractAbiSignatureDto>[],
      final List<SmartContractAbiSignatureDto> inputs =
          const <SmartContractAbiSignatureDto>[]})
      : _outputs = outputs,
        _inputs = inputs,
        super._();

  factory _$SmartContractAbiEntryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartContractAbiEntryDtoImplFromJson(json);

  @override
  @JsonKey(unknownEnumValue: SmartContractAbiEntryType.unknown)
  final SmartContractAbiEntryType type;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey(unknownEnumValue: SmartContractStateMutability.unknown)
  final SmartContractStateMutability stateMutability;
  final List<SmartContractAbiSignatureDto> _outputs;
  @override
  @JsonKey()
  List<SmartContractAbiSignatureDto> get outputs {
    if (_outputs is EqualUnmodifiableListView) return _outputs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outputs);
  }

  final List<SmartContractAbiSignatureDto> _inputs;
  @override
  @JsonKey()
  List<SmartContractAbiSignatureDto> get inputs {
    if (_inputs is EqualUnmodifiableListView) return _inputs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputs);
  }

  @override
  String toString() {
    return 'SmartContractAbiEntryDto(type: $type, name: $name, stateMutability: $stateMutability, outputs: $outputs, inputs: $inputs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartContractAbiEntryDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.stateMutability, stateMutability) ||
                other.stateMutability == stateMutability) &&
            const DeepCollectionEquality().equals(other._outputs, _outputs) &&
            const DeepCollectionEquality().equals(other._inputs, _inputs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      name,
      stateMutability,
      const DeepCollectionEquality().hash(_outputs),
      const DeepCollectionEquality().hash(_inputs));

  /// Create a copy of SmartContractAbiEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartContractAbiEntryDtoImplCopyWith<_$SmartContractAbiEntryDtoImpl>
      get copyWith => __$$SmartContractAbiEntryDtoImplCopyWithImpl<
          _$SmartContractAbiEntryDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartContractAbiEntryDtoImplToJson(
      this,
    );
  }
}

abstract class _SmartContractAbiEntryDto extends SmartContractAbiEntryDto {
  factory _SmartContractAbiEntryDto(
          {@JsonKey(unknownEnumValue: SmartContractAbiEntryType.unknown)
          final SmartContractAbiEntryType type,
          final String name,
          @JsonKey(unknownEnumValue: SmartContractStateMutability.unknown)
          final SmartContractStateMutability stateMutability,
          final List<SmartContractAbiSignatureDto> outputs,
          final List<SmartContractAbiSignatureDto> inputs}) =
      _$SmartContractAbiEntryDtoImpl;
  _SmartContractAbiEntryDto._() : super._();

  factory _SmartContractAbiEntryDto.fromJson(Map<String, dynamic> json) =
      _$SmartContractAbiEntryDtoImpl.fromJson;

  @override
  @JsonKey(unknownEnumValue: SmartContractAbiEntryType.unknown)
  SmartContractAbiEntryType get type;
  @override
  String get name;
  @override
  @JsonKey(unknownEnumValue: SmartContractStateMutability.unknown)
  SmartContractStateMutability get stateMutability;
  @override
  List<SmartContractAbiSignatureDto> get outputs;
  @override
  List<SmartContractAbiSignatureDto> get inputs;

  /// Create a copy of SmartContractAbiEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartContractAbiEntryDtoImplCopyWith<_$SmartContractAbiEntryDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
