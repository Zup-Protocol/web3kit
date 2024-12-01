import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/src/builders/abi/dtos/smart_contract_abi_signature_dto/smart_contract_abi_signature_dto.dart";

part "smart_contact_abi_entry_dto.freezed.dart";
part "smart_contact_abi_entry_dto.g.dart";

enum SmartContractAbiEntryType {
  function,
  tuple,
  unknown;

  bool get isFunction => this == SmartContractAbiEntryType.function;
  bool get isTuple => this == SmartContractAbiEntryType.tuple;
  bool get isUnknown => this == SmartContractAbiEntryType.unknown;
}

enum SmartContractStateMutability {
  view,
  payable,
  nonpayable,
  unknown;

  bool get isView => this == SmartContractStateMutability.view;
}

@freezed
class SmartContractAbiEntryDto with _$SmartContractAbiEntryDto {
  SmartContractAbiEntryDto._();

  @JsonSerializable(explicitToJson: true)
  factory SmartContractAbiEntryDto({
    @Default(SmartContractAbiEntryType.unknown)
    @JsonKey(unknownEnumValue: SmartContractAbiEntryType.unknown)
    SmartContractAbiEntryType type,
    @Default("") String name,
    @Default(SmartContractStateMutability.unknown)
    @JsonKey(unknownEnumValue: SmartContractStateMutability.unknown)
    SmartContractStateMutability stateMutability,
    @Default(<SmartContractAbiSignatureDto>[]) List<SmartContractAbiSignatureDto> outputs,
    @Default(<SmartContractAbiSignatureDto>[]) List<SmartContractAbiSignatureDto> inputs,
  }) = _SmartContractAbiEntryDto;

  factory SmartContractAbiEntryDto.fromJson(Map<String, dynamic> json) => _$SmartContractAbiEntryDtoFromJson(json);

  //   if (entry.inputs.every((input) => input.name.isNotEmpty)) {
  //   method.optionalParameters.addAll(entry.inputs.map((input) {
  //     return Parameter((param) {
  //       param.name = input.name.removeUnderScores;
  //       param.named = true;
  //       param.required = true;
  //       param.type = refer(smartContractTypeToDartType(input));
  //     });
  //   }));
  // } else {
  //   method.requiredParameters.addAll(entry.inputs.map((input) {
  //     return Parameter((param) {
  //       param.name = input.name.removeUnderScores;
  //       param.named = true;
  //       param.type = refer(smartContractTypeToDartType(input));
  //     });
  //   }));
  // }
}
