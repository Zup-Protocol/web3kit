import "package:freezed_annotation/freezed_annotation.dart";

part "smart_contract_abi_output_dto.freezed.dart";
part "smart_contract_abi_output_dto.g.dart";

@freezed
class SmartContractAbiOutputDto with _$SmartContractAbiOutputDto {
  @JsonSerializable(explicitToJson: true)
  factory SmartContractAbiOutputDto({
    @Default("") String name,
    required String type,
    @Default("") String internalType,
  }) = _SmartContractAbiOutputDto;

  factory SmartContractAbiOutputDto.fromJson(Map<String, dynamic> json) => _$SmartContractAbiOutputDtoFromJson(json);
}
