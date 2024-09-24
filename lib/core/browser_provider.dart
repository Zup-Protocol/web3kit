import "package:web3kit/core/core.dart";
import "package:web3kit/src/inject.dart";
import "package:web3kit/src/mocks/ethers_browser_provider.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_browser_provider.js.dart";
import "package:web3kit/src/mocks/ethers_network.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_network.js.dart";
import "package:web3kit/src/mocks/ethers_signer.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_signer.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

class BrowserProvider {
  /// Access the singleton instance of the BrowserProvider
  static BrowserProvider get shared => Inject.shared.browserProvider;

  /// Get a [Signer] for a given [walletProvider].
  ///
  /// The returned [Signer] is connected to the given [walletProvider].
  ///
  /// If the wallet is not connected, it will prompt the user to connect it.
  Future<Signer> getSigner(EthereumProvider walletProvider) async {
    JSEthersBrowserProvider jsBrowserProvider = JSEthersBrowserProvider(walletProvider.jsEthereumProvider);
    JSEthersSigner jsSigner = await (jsBrowserProvider.getSigner()).toDart;

    return Signer(jsSigner, jsBrowserProvider);
  }

  /// Get the current connected network for the given provider, returned as [ChainInfo].
  ///
  /// @param `walletProvider` the wallet's ethereum provider to query the connected network.
  /// Note that the wallet does not need to be connected to make this call
  Future<ChainInfo> getNetwork(EthereumProvider walletProvider) async {
    JSEthersBrowserProvider jsBrowserProvider = JSEthersBrowserProvider(walletProvider.jsEthereumProvider);
    final JSEthersNetwork jsNetwork = await (jsBrowserProvider.getNetwork()).toDart;

    return ChainInfo(
      hexChainId: "0x${((BigInt.parse(jsNetwork.chainId.toString())).toRadixString(16))}",
      chainName: jsNetwork.name.toDart,
    );
  }
}
