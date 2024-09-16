enum EthersError { actionRejected, unsupportedOperation }

extension EthersErrorExtension on EthersError {
  String get code => ["ACTION_REJECTED", "UNSUPPORTED_OPERATION"][index];
}
