import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' hide Cache;
import 'package:web3kit/core/browser_provider.dart';
import 'package:web3kit/core/cache.dart';
import 'package:web3kit/core/core.dart';
import 'package:web3kit/core/dtos/wallet_detail.dart';
import 'package:web3kit/core/dtos/wallet_info.dart';
import 'package:web3kit/core/enums/eip_6963_event.dart';
import 'package:web3kit/core/enums/ethers_error_code.dart';
import 'package:web3kit/core/ethereum_provider.dart';
import 'package:web3kit/core/js/eip_6963/eip_6963_event.js.dart';
import 'package:web3kit/core/js/ethers/ethers_errors.js.dart';

/// Object to interact with Web3 wallets.
/// Can perform actions like connect, send transactions, verify if specific wallet is installed, etc...
class Wallet {
  Wallet(this._browserProvider, this._cache) {
    _getInstalledWallets();
    _setupStreams();
  }

  final BrowserProvider _browserProvider;
  final Cache _cache;
  final StreamController<Signer?> _signerStreamController = StreamController<Signer?>.broadcast();
  final List<WalletDetail> _installedWallets = [];
  EthereumProvider? _connectedProvider;

  /// Stream of the current connected signer
  ///
  /// Emitted every time an user change their account in the wallet. Such as connect, disconnect, change account etc...
  ///
  /// In case of disconnection, it will emit a null event
  Stream<Signer?> get signer => _signerStreamController.stream;

  /// Get the list of installed wallets in the browser, it will include all wallets following the EIP 6963 standard.
  ///
  /// For more info about EIP 6963, please head over to https://eips.ethereum.org/EIPS/eip-6963
  List<WalletDetail> get installedWallets => List.unmodifiable(_installedWallets);

  void _setupStreams() async {
    for (var wallet in _installedWallets) {
      wallet.provider.onAccountsChanged((accounts) async {
        if (accounts.isEmpty) return _notifySignerChange(null);

        _connectedProvider = wallet.provider;
        Signer signer = await _browserProvider.getSigner(wallet.provider);
        _notifySignerChange(signer);
      });
    }
  }

  void _notifySignerChange(Signer? signer) => _signerStreamController.add(signer);

  void _getInstalledWallets() {
    final eventCallback = ((JSEIP6963Event event) {
      _installedWallets.add(
        WalletDetail(
          info: WalletInfo(
            name: event.detail.info.name.toDart,
            icon: event.detail.info.icon.toDart,
            rdns: event.detail.info.rdns.toDart,
          ),
          provider: EthereumProvider(event.detail.provider),
        ),
      );
    }).toJS;

    window.addEventListener(EIP6963Event.announceProvider.name, eventCallback);
    window.dispatchEvent(JSEIP6963Event(EIP6963Event.requestProvider.name.toJS));
    window.removeEventListener(EIP6963Event.announceProvider.name, eventCallback);
  }

  /// Connect to a specific wallet.
  ///
  /// `wallet` is the intended wallet to connect. You can get this in the `installedWallets` property of this class
  Future<Signer> connect(WalletDetail wallet) async {
    try {
      final signer = await _browserProvider.getSigner(wallet.provider);
      _connectedProvider = wallet.provider;
      _notifySignerChange(signer);
      _cache.setWalletConnectionState(wallet.info.rdns);
      return signer;
    } catch (e) {
      bool isEthersError = (e is JSObject && (e).isA<JSEthersError>());

      if (isEthersError && (e as JSEthersError).code.toDart == EthersError.actionRejected.code) {
        throw UserRejectedAction();
      }

      rethrow;
    }
  }

  /// Disconnect from the current connected wallet
  Future<void> disconnect() async {
    _notifySignerChange(null);

    await _cache.setWalletConnectionState(null);

    try {
      await _connectedProvider!.revokePermissions();
    } catch (_) {
      // as it will revert if the current connected wallet did not implement MIP-2 standard
      // we can safely ignore the error
    }
  }
}
