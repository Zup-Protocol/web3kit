import 'dart:js_interop';

import 'package:web3kit/bridges/ethers.js.dart';
import 'package:web3kit/bridges/wallet.js.dart';
import 'package:web3kit/core/core.dart';

class Wallet {
  static final shared = Wallet();

  bool isWalletInstalled(WalletBrand wallet) => JSWallet.shared.isWalletInstalled(wallet.provider.toJS);
  Future<void> connect(WalletBrand wallet) async => await JSEthers.shared.connectWallet(wallet.provider.toJS).toDart;
}
