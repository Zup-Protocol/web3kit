import "package:freezed_annotation/freezed_annotation.dart";

@internal
enum EthersError {
  actionRejected,
  unsupportedOperation;

  String get code => ["ACTION_REJECTED", "UNSUPPORTED_OPERATION"][index];
}
