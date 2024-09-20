import "package:equatable/equatable.dart";
import "package:web3kit/src/enums/ethereum_event.dart";
import "package:web3kit/src/enums/ethereum_request.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethereum_provider.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/package_mocks/js_interop_unsafe_mock.dart"
    if (dart.library.html) "dart:js_interop_unsafe";

/// Dart abstraction of the ethereum provider in the browser.
class EthereumProvider extends Equatable {
  const EthereumProvider(this.jsEthereumProvider);
  final JSEthereumProvider jsEthereumProvider;

  /// add a listener to the accountsChanged event from the ethereum provider
  ///
  /// `callback` - callback function that will be called on every accounts change, such as connecting new accounts, disconnecting etc...///
  ///
  /// `accounts` param in `callback` is the list of accounts that are currently connected to the application. The first item of the list
  /// will be the active, that the user is currently using. The other items are connected, but are not the active one.
  void onAccountsChanged(Function(List<String> accounts) callback) {
    jsEthereumProvider.on(
        EthereumEvent.accountsChanged.name.toJS,
        ((JSArray<JSString> accounts) {
          final List<JSString> jsArrayToList = accounts.toDart;
          List<String> accountsInDart = [];

          for (var i = 0; i < jsArrayToList.length; i++) {
            accountsInDart.add(jsArrayToList[i].toDart);
          }

          callback((accountsInDart));
        }).toJS);
  }

  /// Revoke access to the current wallet, using the metamask's revokePermissions MIP-2 standard.
  /// For more info about the MIP-2, please head over to https://github.com/MetaMask/metamask-improvement-proposals/blob/main/MIPs/mip-2.md
  ///
  /// If the current wallet does not support this standard, it will throw an error. Then you should implement your custom disconnection logic
  Future<void> revokePermissions() async {
    final requestObject = JSObject()
      ..setProperty("method".toJS, EthereumRequest.revokePermissions.method.toJS)
      ..setProperty(
          "params".toJS,
          [
            {
              "eth_accounts": {},
            }
          ].jsify());

    await jsEthereumProvider.request(requestObject).toDart;
  }

  @override
  List<Object?> get props => [jsEthereumProvider];
}
