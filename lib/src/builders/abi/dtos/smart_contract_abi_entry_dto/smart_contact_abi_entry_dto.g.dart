// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_contact_abi_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmartContractAbiEntryDtoImpl _$$SmartContractAbiEntryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartContractAbiEntryDtoImpl(
      type: $enumDecodeNullable(
              _$SmartContractAbiEntryTypeEnumMap, json['type'],
              unknownValue: SmartContractAbiEntryType.unknown) ??
          SmartContractAbiEntryType.unknown,
      name: json['name'] as String? ?? "",
      outputs: (json['outputs'] as List<dynamic>?)
              ?.map((e) =>
                  SmartContractAbiOutputDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SmartContractAbiOutputDto>[],
    );

Map<String, dynamic> _$$SmartContractAbiEntryDtoImplToJson(
        _$SmartContractAbiEntryDtoImpl instance) =>
    <String, dynamic>{
      'type': _$SmartContractAbiEntryTypeEnumMap[instance.type]!,
      'name': instance.name,
      'outputs': instance.outputs.map((e) => e.toJson()).toList(),
    };

const _$SmartContractAbiEntryTypeEnumMap = {
  SmartContractAbiEntryType.function: 'function',
  SmartContractAbiEntryType.unknown: 'unknown',
};
