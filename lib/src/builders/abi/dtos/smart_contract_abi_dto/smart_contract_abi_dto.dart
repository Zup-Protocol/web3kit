import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/src/builders/abi/dtos/smart_contract_abi_entry_dto/smart_contact_abi_entry_dto.dart";

part "smart_contract_abi_dto.freezed.dart";
part "smart_contract_abi_dto.g.dart";

@freezed
class SmartContractAbiDto with _$SmartContractAbiDto {
  static const entriesJsonName = "entries";

  @JsonSerializable(explicitToJson: true)
  const factory SmartContractAbiDto({
    @JsonKey(name: SmartContractAbiDto.entriesJsonName) required List<SmartContractAbiEntryDto> entries,
  }) = _SmartContractAbiDto;

  factory SmartContractAbiDto.fromJson(Map<String, dynamic> json) => _$SmartContractAbiDtoFromJson(json);
}
