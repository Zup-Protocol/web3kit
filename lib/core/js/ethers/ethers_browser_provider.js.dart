@JS()
library ethers_browser_provider;

import 'dart:js_interop';

import 'package:web3kit/core/js/ethereum_provider.js.dart';
import 'package:web3kit/core/js/ethers/ethers_signer.js.dart';

@JS("ethers.BrowserProvider")
extension type JSEthersBrowserProvider._(JSObject _) implements JSObject {
  external JSEthersBrowserProvider(JSEthereumProvider ethereumProvider);

  external JSPromise<JSEthersSigner> getSigner();

  external JSPromise<JSString?> lookupAddress(JSString address);
}
