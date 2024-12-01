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
      stateMutability: $enumDecodeNullable(
              _$SmartContractStateMutabilityEnumMap, json['stateMutability'],
              unknownValue: SmartContractStateMutability.unknown) ??
          SmartContractStateMutability.unknown,
      outputs: (json['outputs'] as List<dynamic>?)
              ?.map((e) => SmartContractAbiSignatureDto.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const <SmartContractAbiSignatureDto>[],
      inputs: (json['inputs'] as List<dynamic>?)
              ?.map((e) => SmartContractAbiSignatureDto.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const <SmartContractAbiSignatureDto>[],
    );

Map<String, dynamic> _$$SmartContractAbiEntryDtoImplToJson(
        _$SmartContractAbiEntryDtoImpl instance) =>
    <String, dynamic>{
      'type': _$SmartContractAbiEntryTypeEnumMap[instance.type]!,
      'name': instance.name,
      'stateMutability':
          _$SmartContractStateMutabilityEnumMap[instance.stateMutability]!,
      'outputs': instance.outputs.map((e) => e.toJson()).toList(),
      'inputs': instance.inputs.map((e) => e.toJson()).toList(),
    };

const _$SmartContractAbiEntryTypeEnumMap = {
  SmartContractAbiEntryType.function: 'function',
  SmartContractAbiEntryType.tuple: 'tuple',
  SmartContractAbiEntryType.unknown: 'unknown',
};

const _$SmartContractStateMutabilityEnumMap = {
  SmartContractStateMutability.view: 'view',
  SmartContractStateMutability.payable: 'payable',
  SmartContractStateMutability.nonpayable: 'nonpayable',
  SmartContractStateMutability.unknown: 'unknown',
};
