import "dart:async";

import "package:collection/collection.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/cache.dart";
import "package:web3kit/src/enums/eip_6963_event_enum.dart";
import "package:web3kit/src/enums/ethers_error_code.dart";
import "package:web3kit/src/ethers/ethers_exceptions.dart";
import "package:web3kit/src/mocks/eip_6963_event.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/eip_6963/eip_6963_event.js.dart";
import "package:web3kit/src/mocks/ethers_errors.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_error.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart" if (dart.library.html) "package:web/web.dart" hide Cache;

/// Object to interact with Web3 wallets.
/// Can perform actions like connect, send transactions, verify if specific wallet is installed, etc...
class Wallet {
  Wallet(this._browserProvider, this._cache, this._window) {
    _getInstalledWallets();
    _setupStreams();
  }

  /// Access the singleton instance of the Wallet Object
  static final Wallet shared = Web3Client.shared.wallet;

  final BrowserProvider _browserProvider;
  final Cache _cache;
  final Window _window;
  final StreamController<Signer?> _signerStreamController = StreamController<Signer?>.broadcast();
  final List<WalletDetail> _installedWallets = [];
  EthereumProvider? _connectedProvider;

  /// Stream of the current connected signer
  ///
  /// Emitted every time an user change their account in the wallet. Such as connect, disconnect, change account etc...
  ///
  /// In case of disconnection, it will emit a null event
  Stream<Signer?> get signerStream => _signerStreamController.stream;

  /// Get the list of installed wallets in the browser, it will include all wallets following the EIP 6963 standard.
  ///
  /// For more info about EIP 6963, please head over to https://eips.ethereum.org/EIPS/eip-6963
  List<WalletDetail> get installedWallets => List.unmodifiable(_installedWallets);

  /// Get the current connected wallet provider.
  ///
  /// Returns null if no wallet is connected
  EthereumProvider? get connectedProvider => _connectedProvider;

  void _setupStreams() async {
    for (var wallet in _installedWallets) {
      wallet.provider.onAccountsChanged((accounts) async {
        if (accounts.isEmpty) {
          _connectedProvider = null;
          return _notifySignerChange(null);
        }

        _connectedProvider = wallet.provider;
        Signer signer = await _browserProvider.getSigner(wallet.provider);
        _notifySignerChange(signer);
      });
    }
  }

  void _notifySignerChange(Signer? signer) => _signerStreamController.add(signer);

  void _getInstalledWallets() {
    final eventCallback = (JSEIP6963Event event) {
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
    }.toJS;

    _window.addEventListener(EIP6963EventEnum.announceProvider.name, eventCallback);
    _window.dispatchEvent(JSEIP6963Event(EIP6963EventEnum.requestProvider.name.toJS));
    _window.removeEventListener(EIP6963EventEnum.announceProvider.name, eventCallback);
  }

  /// Connect to a wallet that was connected, and wasn't disconnected in the same session.
  /// If there are no previous cached connections, it will return `null` as the Signer.
  ///
  /// This method is useful to keep a user wallet connected between sessions, without asking
  /// him to connect again.
  Future<Signer?> connectCachedWallet() async {
    String? cachedConnectedWalletRDNS = await _cache.getConnectedWallet();

    WalletDetail? connectedWallet = _installedWallets.firstWhereOrNull((wallet) {
      return wallet.info.rdns == cachedConnectedWalletRDNS;
    });

    return connectedWallet != null ? connect(connectedWallet) : null;
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
