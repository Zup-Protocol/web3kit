@JS()
library ethers_bridge;

import 'dart:js_interop';

@JS("Ethers")
extension type JSEthers._(JSObject _) implements JSObject {
  static final shared = JSEthers();
  external JSEthers();

  external JSPromise connectWallet(JSString provider);
}
