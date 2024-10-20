import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/src/builders/abi/dtos/smart_contract_abi_output_dto/smart_contract_abi_output_dto.dart";

part "smart_contact_abi_entry_dto.freezed.dart";
part "smart_contact_abi_entry_dto.g.dart";

enum SmartContractAbiEntryType { function, unknown }

@freezed
class SmartContractAbiEntryDto with _$SmartContractAbiEntryDto {
  @JsonSerializable(explicitToJson: true)
  factory SmartContractAbiEntryDto({
    @Default(SmartContractAbiEntryType.unknown)
    @JsonKey(unknownEnumValue: SmartContractAbiEntryType.unknown)
    SmartContractAbiEntryType type,
    @Default("") String name,
    @Default(<SmartContractAbiOutputDto>[]) List<SmartContractAbiOutputDto> outputs,
  }) = _SmartContractAbiEntryDto;

  factory SmartContractAbiEntryDto.fromJson(Map<String, dynamic> json) => _$SmartContractAbiEntryDtoFromJson(json);
}
