import 'dart:js_interop';

import 'package:web3kit/bridges/wallet.js.dart';
import 'package:web3kit/core/core.dart';

/// Object to interact with Web3 wallets.
/// Can perform actions like connect, send transactions, verify if specific wallet is installed, etc...
class Wallet {
  Wallet({required this.ethers});

  Ethers ethers;

  /// Verify if an specific wallet is installed in the current browser session. Such as Metamask, Rabby etc...
  bool isWalletInstalled(WalletBrand wallet) => JSWallet.shared.isWalletInstalled(wallet.provider.toJS);

  /// Connect to a specific wallet.
  ///
  /// If the target wallet is not support by web3kit, but implements the metamask method of connection, use `metamask` as target wallet
  Future<void> connect(WalletBrand wallet) async => await ethers.connectWallet(wallet);
}
