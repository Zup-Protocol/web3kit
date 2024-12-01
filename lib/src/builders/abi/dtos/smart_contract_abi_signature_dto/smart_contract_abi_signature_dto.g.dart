// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_contract_abi_signature_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmartContractAbiSignatureDtoImpl _$$SmartContractAbiSignatureDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartContractAbiSignatureDtoImpl(
      name: json['name'] as String? ?? "",
      type: json['type'] as String,
      internalType: json['internalType'] as String? ?? "",
      components: (json['components'] as List<dynamic>?)
              ?.map((e) => SmartContractAbiSignatureDto.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const <SmartContractAbiSignatureDto>[],
    );

Map<String, dynamic> _$$SmartContractAbiSignatureDtoImplToJson(
        _$SmartContractAbiSignatureDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'internalType': instance.internalType,
      'components': instance.components.map((e) => e.toJson()).toList(),
    };
