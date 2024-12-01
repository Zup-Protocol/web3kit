import "package:freezed_annotation/freezed_annotation.dart";

part "smart_contract_abi_signature_dto.freezed.dart";
part "smart_contract_abi_signature_dto.g.dart";

@freezed
class SmartContractAbiSignatureDto with _$SmartContractAbiSignatureDto {
  @JsonSerializable(explicitToJson: true)
  factory SmartContractAbiSignatureDto({
    @Default("") String name,
    required String type,
    @Default("") String internalType,
    @Default(<SmartContractAbiSignatureDto>[]) List<SmartContractAbiSignatureDto> components,
  }) = _SmartContractAbiSignatureDto;

  factory SmartContractAbiSignatureDto.fromJson(Map<String, dynamic> json) =>
      _$SmartContractAbiSignatureDtoFromJson(json);
}
