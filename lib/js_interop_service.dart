@JS()
library js_interop;

import 'dart:js_interop';

@JS()
extension type Ethers._(JSObject _) implements JSObject {
  external Ethers();
  external void connectWallet();
}
