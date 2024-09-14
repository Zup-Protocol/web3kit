import 'dart:js_interop';

import 'package:web3kit/bridges/ethers.js.dart';
import 'package:web3kit/bridges/ethers_errors.js.dart';
import 'package:web3kit/core/core.dart';
import 'package:web3kit/core/extensions/js_ethers_error_extension.dart';

/// Object to interact directly with EthersJS.
/// For more info about EthersJS see [https://docs.ethers.org/v6/]
class Ethers {
  /// Connect to a specific wallet.
  ///
  /// If the target wallet is not support by web3kit, but implements the metamask method of connection, use `metamask` as target wallet
  Future<void> connectWallet(WalletBrand wallet) async {
    try {
      await JSEthers.shared.connectWallet(wallet.provider.toJS).toDart;
    } catch (e) {
      bool isEthersError = (e is JSEthersError);
      print("did not passed brrr");

      if (isEthersError && e.isUserRejectedAction) throw UserRejectedAction();

      print("did passed brrr");

      rethrow;
    }
  }
}
