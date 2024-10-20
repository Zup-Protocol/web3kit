// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_contract_abi_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SmartContractAbiDto _$SmartContractAbiDtoFromJson(Map<String, dynamic> json) {
  return _SmartContractAbiDto.fromJson(json);
}

/// @nodoc
mixin _$SmartContractAbiDto {
  @JsonKey(name: SmartContractAbiDto.entriesJsonName)
  List<SmartContractAbiEntryDto> get entries =>
      throw _privateConstructorUsedError;

  /// Serializes this SmartContractAbiDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartContractAbiDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartContractAbiDtoCopyWith<SmartContractAbiDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartContractAbiDtoCopyWith<$Res> {
  factory $SmartContractAbiDtoCopyWith(
          SmartContractAbiDto value, $Res Function(SmartContractAbiDto) then) =
      _$SmartContractAbiDtoCopyWithImpl<$Res, SmartContractAbiDto>;
  @useResult
  $Res call(
      {@JsonKey(name: SmartContractAbiDto.entriesJsonName)
      List<SmartContractAbiEntryDto> entries});
}

/// @nodoc
class _$SmartContractAbiDtoCopyWithImpl<$Res, $Val extends SmartContractAbiDto>
    implements $SmartContractAbiDtoCopyWith<$Res> {
  _$SmartContractAbiDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartContractAbiDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<SmartContractAbiEntryDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmartContractAbiDtoImplCopyWith<$Res>
    implements $SmartContractAbiDtoCopyWith<$Res> {
  factory _$$SmartContractAbiDtoImplCopyWith(_$SmartContractAbiDtoImpl value,
          $Res Function(_$SmartContractAbiDtoImpl) then) =
      __$$SmartContractAbiDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: SmartContractAbiDto.entriesJsonName)
      List<SmartContractAbiEntryDto> entries});
}

/// @nodoc
class __$$SmartContractAbiDtoImplCopyWithImpl<$Res>
    extends _$SmartContractAbiDtoCopyWithImpl<$Res, _$SmartContractAbiDtoImpl>
    implements _$$SmartContractAbiDtoImplCopyWith<$Res> {
  __$$SmartContractAbiDtoImplCopyWithImpl(_$SmartContractAbiDtoImpl _value,
      $Res Function(_$SmartContractAbiDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SmartContractAbiDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
  }) {
    return _then(_$SmartContractAbiDtoImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<SmartContractAbiEntryDto>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SmartContractAbiDtoImpl implements _SmartContractAbiDto {
  const _$SmartContractAbiDtoImpl(
      {@JsonKey(name: SmartContractAbiDto.entriesJsonName)
      required final List<SmartContractAbiEntryDto> entries})
      : _entries = entries;

  factory _$SmartContractAbiDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartContractAbiDtoImplFromJson(json);

  final List<SmartContractAbiEntryDto> _entries;
  @override
  @JsonKey(name: SmartContractAbiDto.entriesJsonName)
  List<SmartContractAbiEntryDto> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  String toString() {
    return 'SmartContractAbiDto(entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartContractAbiDtoImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_entries));

  /// Create a copy of SmartContractAbiDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartContractAbiDtoImplCopyWith<_$SmartContractAbiDtoImpl> get copyWith =>
      __$$SmartContractAbiDtoImplCopyWithImpl<_$SmartContractAbiDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartContractAbiDtoImplToJson(
      this,
    );
  }
}

abstract class _SmartContractAbiDto implements SmartContractAbiDto {
  const factory _SmartContractAbiDto(
          {@JsonKey(name: SmartContractAbiDto.entriesJsonName)
          required final List<SmartContractAbiEntryDto> entries}) =
      _$SmartContractAbiDtoImpl;

  factory _SmartContractAbiDto.fromJson(Map<String, dynamic> json) =
      _$SmartContractAbiDtoImpl.fromJson;

  @override
  @JsonKey(name: SmartContractAbiDto.entriesJsonName)
  List<SmartContractAbiEntryDto> get entries;

  /// Create a copy of SmartContractAbiDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartContractAbiDtoImplCopyWith<_$SmartContractAbiDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
