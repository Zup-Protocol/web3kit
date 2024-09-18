@JS()
library ethers_browser_provider;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethereum_provider.js.dart";
import "package:web3kit/src/js/ethers/ethers_signer.js.dart";

@JS("ethers.BrowserProvider")
extension type JSEthersBrowserProvider._(JSObject _) implements JSObject {
  external JSEthersBrowserProvider(JSEthereumProvider ethereumProvider);

  external JSPromise<JSEthersSigner> getSigner();

  external JSPromise<JSString?> lookupAddress(JSString address);
}
