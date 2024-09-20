import "package:flutter/foundation.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart";
import "package:web3kit/src/mocks/ethers_signer.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthersBrowserProvider {
  JSEthersBrowserProvider(JSEthereumProvider ethereumProvider) {
    lastCreatedInstance = this;
    jsEthereumProvider = ethereumProvider;
  }

  @visibleForTesting
  static JSEthersBrowserProvider? lastCreatedInstance;

  @visibleForTesting
  JSEthereumProvider? jsEthereumProvider;

  @visibleForTesting
  static JSEthersSigner jsEthersSigner = JSEthersSigner();

  JSPromise<JSEthersSigner> getSigner() => JSPromise(jsEthersSigner);

  JSPromise<JSString?> lookupAddress(JSString address) => JSPromise(const JSString(""));
}
