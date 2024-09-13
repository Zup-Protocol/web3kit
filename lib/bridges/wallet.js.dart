@JS()
library wallet_bridge;

import 'dart:js_interop';

@JS("Wallet")
extension type JSWallet._(JSObject _) implements JSObject {
  static final shared = JSWallet();

  external JSWallet();

  external void connect();
  external bool isWalletInstalled(JSString provider);
}
