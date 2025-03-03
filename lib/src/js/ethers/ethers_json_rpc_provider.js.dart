@JS()
library ethers_rpc_provider;

import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethereum_provider.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("ethers.JsonRpcProvider")
extension type JSEthersJsonRpcProvider._(JSEthereumProvider _) implements JSEthereumProvider {
  external JSEthersJsonRpcProvider(JSString rpcUrl);
}
