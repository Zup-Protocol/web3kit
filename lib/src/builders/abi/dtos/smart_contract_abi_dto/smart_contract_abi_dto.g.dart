// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_contract_abi_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmartContractAbiDtoImpl _$$SmartContractAbiDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartContractAbiDtoImpl(
      entries: (json['entries'] as List<dynamic>)
          .map((e) =>
              SmartContractAbiEntryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SmartContractAbiDtoImplToJson(
        _$SmartContractAbiDtoImpl instance) =>
    <String, dynamic>{
      'entries': instance.entries.map((e) => e.toJson()).toList(),
    };
