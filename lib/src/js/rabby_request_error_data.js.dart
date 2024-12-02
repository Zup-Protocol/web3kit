@JS()
library rabby_request_error;

import "package:web3kit/src/mocks/ethereum_request_error.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethereum_request_error.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("data")
extension type JSRabbyRequestErrorData._(JSObject _) implements JSObject {
  external JSRabbyRequestErrorData();

  external JSEthereumRequestError? get originalError;
}
