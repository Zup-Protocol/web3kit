import 'dart:js_interop';

import 'package:web3kit/bridges/ethers_errors.js.dart';
import 'package:web3kit/core/ethers/ethers_error_codes.dart';

extension JSEthersErrors on JSEthersError {
  /// Get if the current error is of type user rejected action.
  bool get isUserRejectedAction {
    try {
      return info.userRejectedActionInfo.code.toDartInt.isUserRejectedActionCode;
    } catch (_) {
      return false;
    }
  }
}
