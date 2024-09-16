import 'package:collection/collection.dart';
import 'package:web3kit/core/cache.dart';
import 'package:web3kit/core/dtos/wallet_detail.dart';
import 'package:web3kit/core/inject.dart';
import 'package:web3kit/core/wallet.dart';

/// Client for interacting with Web3.
class Web3client {
  Web3client._();

  static Web3client? _shared;
  final Cache _cache = inject<Cache>();

  /// Access the browser wallets and interact with them.
  final Wallet wallet = inject<Wallet>();

  /// Get the singleton instance of Web3client
  static Web3client get shared {
    if (_shared == null) {
      throw Exception(
        "Web3client has not been initialized. Please initialize it with `Web3client.initialize()`, before using the client",
      );
    }

    return _shared!;
  }

  /// Initializes the client to be able to use it.
  /// This function should be called only once
  ///
  /// @param `automaticallyConnectWallet` should be set to `true` if you want to automatically connect to the user's wallet once the client is initialized.
  /// it will automatically update the state of the `connectButton` from web3kit UI Kit if you are using it. It also emits the event that the signer has changed.
  /// If you are not using web3kit connect button, you should listen to this event in order to update your UI.
  ///
  /// Note that it will only automatically connect if it was previously connected, and has not been disconnected.
  static Future<void> initialize({bool automaticallyConnectWallet = true}) async {
    if (_shared != null) {
      throw Exception("Web3client has already been initialized. Please use `Web3client.shared` instead");
    }

    await setupInjections();
    _shared = Web3client._();
    if (automaticallyConnectWallet) _shared!._connectCachedWallet();
  }

  void _connectCachedWallet() async {
    String? cachedConnectedWalletRDNS = await _cache.getConnectedWallet();

    WalletDetail? connectedWallet = _shared!.wallet.installedWallets.firstWhereOrNull((wallet) {
      return wallet.info.rdns == cachedConnectedWalletRDNS;
    });

    if (connectedWallet != null) _shared!.wallet.connect(connectedWallet);
  }
}
