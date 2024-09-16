import 'dart:js_interop';

import 'package:web3kit/core/core.dart';
import 'package:web3kit/core/ethereum_provider.dart';
import 'package:web3kit/core/js/ethers/ethers_browser_provider.js.dart';
import 'package:web3kit/core/js/ethers/ethers_signer.js.dart';

class BrowserProvider {
  /// Get a [Signer] for a given [wallet].
  ///
  /// The returned [Signer] is connected to the given [wallet].
  ///
  /// If the wallet is not connected, it will prompt the user to connect it.
  Future<Signer> getSigner(EthereumProvider walletProvider) async {
    JSEthersBrowserProvider jsBrowserProvider = JSEthersBrowserProvider(walletProvider.jsEthereumProvider);
    JSEthersSigner jsSigner = await (jsBrowserProvider.getSigner()).toDart;

    return Signer(jsSigner, jsBrowserProvider);
  }
}
