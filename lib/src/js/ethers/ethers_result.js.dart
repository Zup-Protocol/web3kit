@JS()
library ethers_result;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("ethers.Result")
extension type JSEthersResult._(JSObject _) implements JSObject {
  external JSEthersResult();

  external JSAny getValue(JSString key);
}
