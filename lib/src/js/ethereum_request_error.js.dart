@JS()
library ethereum_request_error;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("Error")
extension type JSEthereumRequestError._(JSObject _) implements JSObject {
  external JSEthereumRequestError(JSNumber code, JSString message, JSString stack);

  external JSNumber get code;
}
