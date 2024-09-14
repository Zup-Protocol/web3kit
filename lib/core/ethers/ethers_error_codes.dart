class EthersErrorCodes {
  static const int userRejectedAction = 4001;
}

extension EthersErrorCodesExtension on int {
  bool get isUserRejectedActionCode => this == EthersErrorCodes.userRejectedAction;
}
