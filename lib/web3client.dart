import 'package:web3kit/core/inject.dart';
import 'package:web3kit/core/wallet.dart';

/// Client for interacting with Web3.
class Web3client {
  Web3client._();

  static Web3client? _shared;

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
  static Future<void> initialize() async {
    if (_shared != null) {
      throw Exception("Web3client has already been initialized. Please use `Web3client.shared` instead");
    }

    await setupInjections();
    _shared = Web3client._();
  }

  /// Get an instance of the Wallet Object
  final Wallet wallet = inject<Wallet>();
}
