@JS()
library ethers_network;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("Network")
extension type JSEthersNetwork._(JSObject _) implements JSObject {
  external JSEthersNetwork();

  external JSBigInt get chainId;
  external JSString get name;
}
