@JS()
library ethers_errors_bridge;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("Error")
extension type JSEthersError._(JSObject _) implements JSObject {
  external JSEthersError(JSString code);

  external JSString get code;
}
