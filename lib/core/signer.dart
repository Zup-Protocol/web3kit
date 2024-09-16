import 'dart:js_interop';

import 'package:web3kit/core/enums/ethers_error_code.dart';
import 'package:web3kit/core/js/ethers/ethers_browser_provider.js.dart';
import 'package:web3kit/core/js/ethers/ethers_errors.js.dart';
import 'package:web3kit/core/js/ethers/ethers_signer.js.dart';

/// Signer of a connected Wallet.
class Signer {
  Signer(this._ethersSigner, this._ethersBrowserProvider);

  final JSEthersSigner _ethersSigner;
  final JSEthersBrowserProvider _ethersBrowserProvider;

  /// Get the address of the connected wallet
  Future<String> get address async => (await _ethersSigner.getAddress().toDart).toDart;

  /// get the ENS name of the connected wallet (if available). If non-existent, returns null
  Future<String?> get ensName async {
    try {
      return (await _ethersBrowserProvider.lookupAddress((await address).toJS).toDart)?.toDart;
    } catch (e) {
      bool isEthersError = e is JSObject && (e).isA<JSEthersError>();
      if (isEthersError && (e as JSEthersError).code.toDart == EthersError.unsupportedOperation.code) {
        return null;
      }

      rethrow;
    }
  }
}
