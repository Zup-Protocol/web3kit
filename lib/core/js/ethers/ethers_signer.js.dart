@JS()
library ethers_signer_bridge;

import 'dart:js_interop';

extension type JSEthersSigner._(JSObject _) implements JSObject {
  external JSEthersSigner();

  external JSPromise<JSString> getAddress();
}
