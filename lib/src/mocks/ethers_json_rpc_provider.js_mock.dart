import "package:flutter/material.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthersJsonRpcProvider extends JSEthereumProvider {
  JSEthersJsonRpcProvider(this.rpcUrl) {
    lastRpcUrl = rpcUrl.toDart;
  }

  final JSString rpcUrl;

  @visibleForTesting
  static String? lastRpcUrl;
}
