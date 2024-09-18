import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/core/browser_provider.dart";
import "package:web3kit/core/wallet.dart";
import "package:web3kit/src/inject.dart";

class Web3Client {
  Web3Client(this.wallet, this.browserProvider);

  static Web3Client? _shared;

  @internal
  final Wallet wallet;

  @internal
  final BrowserProvider browserProvider;

  /// Get the shared instance of the Web3Client.
  ///
  /// Should not be used to call any of the variables in the client. Instead use directly the shared instance of the Class.
  ///
  /// ```dart
  /// // BAD:
  /// Web3Client.shared.wallet
  ///
  /// // GOOD:
  /// Wallet.shared
  /// ```
  static Web3Client get shared {
    if (_shared == null) {
      throw "Web3client has not been initialized. Please initialize it with `Web3client.initialize()`, before using the client";
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
  /// Note that it will only automatically connect if it was previously connected, and has not been disconnected in the same session.
  static Future<void> initialize({bool automaticallyConnectWallet = true}) async {
    // (DEV) -> This function should do nothing more than setting up to call the `rawInitialize` function, and calling it.
    // It was made like this to make it testable and mockable, while maintaining an easy to use API, without the need to
    // instantiate it in the client side (app), which is not a good UX for the package user.
    await setupInjections();
    await rawInitialize(
      automaticallyConnectWallet: automaticallyConnectWallet,
      browserProvider: inject<BrowserProvider>(),
      wallet: inject<Wallet>(),
    );
  }

  @visibleForTesting
  static Future<void> rawInitialize({
    required bool automaticallyConnectWallet,
    required BrowserProvider browserProvider,
    required Wallet wallet,
  }) async {
    if (_shared != null) throw "Web3client has already been initialized. Please use `Web3client.shared` instead";

    _shared = Web3Client(wallet, browserProvider);
    if (automaticallyConnectWallet) shared.wallet.connectCachedWallet();
  }

  @visibleForTesting
  static void dispose() => _shared = null;
}
