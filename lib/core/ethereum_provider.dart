import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web3kit/core/enums/ethereum_event.dart';
import 'package:web3kit/core/enums/ethereum_request.dart';
import 'package:web3kit/core/js/ethereum_provider.js.dart';

/// Dart abstraction of the ethereum provider in the browser.
class EthereumProvider {
  EthereumProvider(this.jsEthereumProvider);

  final JSEthereumProvider jsEthereumProvider;

  /// add a listener to the accountsChanged event from the ethereum provider
  ///
  /// `callback` - callback function that will be called on every accounts change, such as connecting new accounts, disconnecting etc...///
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
}
