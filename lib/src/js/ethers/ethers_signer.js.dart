@JS()
library ethers_signer_bridge;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

extension type JSEthersSigner._(JSObject _) implements JSObject {
  external JSEthersSigner();

  external JSPromise<JSString> getAddress();
}
