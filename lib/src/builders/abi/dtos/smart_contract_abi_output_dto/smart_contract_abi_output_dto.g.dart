// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_contract_abi_output_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmartContractAbiOutputDtoImpl _$$SmartContractAbiOutputDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartContractAbiOutputDtoImpl(
      name: json['name'] as String? ?? "",
      type: json['type'] as String,
      internalType: json['internalType'] as String? ?? "",
    );

Map<String, dynamic> _$$SmartContractAbiOutputDtoImplToJson(
        _$SmartContractAbiOutputDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'internalType': instance.internalType,
    };
