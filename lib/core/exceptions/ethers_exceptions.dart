import "package:web3kit/src/enums/ethers_error_code.dart";
import "package:web3kit/src/mocks/ethers_errors.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_error.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

abstract class EthersException<T extends EthersException<T>> {
  String get errorCode;

  T tryParseError(Object e) {
    bool isEthersError = (e is JSObject && (e).isA<JSEthersError>());
    if (!isEthersError) throw e;

    if ((e as JSEthersError).code.toDart == (this as T).errorCode) {
      throw this as T;
    }

    throw e;
  }
}

class UserRejectedAction extends EthersException<UserRejectedAction> {
  @override
  String get errorCode => EthersError.actionRejected.code;
}
