import "package:equatable/equatable.dart";
import "package:web3kit/src/enums/ethereum_event.dart";
import "package:web3kit/src/enums/ethereum_request.dart";
import "package:web3kit/src/extensions/js_object_extension.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethereum_provider.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/package_mocks/js_interop_unsafe_mock.dart"
    if (dart.library.html) "dart:js_interop_unsafe";
import "package:web3kit/web3kit.dart";

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

  /// Switch the current wallet's network to the given chain Id's network.
  ///
  /// @param `hexChainId` the chainId to switch in Hex String. E.g, Ethereum mainnet has an ChainId 1, then it will be "0x1"
  ///
  /// If the network is not added in the wallet, it will throw
  Future<void> switchChain(String hexChainId) async {
    final requestObject = JSObject().getEthereumRequestObject(
      EthereumRequest.switchEthereumChain.method,
      [
        {
          "chainId": hexChainId.toJS,
        }
      ],
    );

    await jsEthereumProvider.request(requestObject).toDart;
  }

  /// Add a given network to the connected provider.
  ///
  /// @param `networkInfo` the information about the network to be added.
  Future<void> addChain(ChainInfo chainInfo) async {
    assert(
      (chainInfo.rpcUrls != null) && chainInfo.rpcUrls!.isNotEmpty,
      "To add a network, at least one RPC URL must be provided",
    );

    assert(chainInfo.nativeCurrency != null, "To add a network, a native currency must be provided");

    final requestObject = JSObject().getEthereumRequestObject(EthereumRequest.addEthereumChain.method, [
      {
        "chainId": chainInfo.hexChainId.toJS,
        if (chainInfo.chainName != null) "chainName": chainInfo.chainName!.toJS,
        "rpcUrls": chainInfo.rpcUrls!.jsify(),
        if (chainInfo.iconsURLs != null) "iconUrls": chainInfo.iconsURLs!.jsify(),
        "nativeCurrency": JSObject()
          ..setProperty("name".toJS, chainInfo.nativeCurrency!.name.toJS)
          ..setProperty("symbol".toJS, chainInfo.nativeCurrency!.symbol.toJS)
          ..setProperty("decimals".toJS, chainInfo.nativeCurrency!.decimals.toJS),
        if (chainInfo.blockExplorerUrls != null) "blockExplorerUrls": chainInfo.blockExplorerUrls!.jsify(),
      }
    ]);

    await jsEthereumProvider.request(requestObject).toDart;
  }

  /// Revoke access to the current wallet, using the metamask's revokePermissions MIP-2 standard.
  /// For more info about the MIP-2, please head over to https://github.com/MetaMask/metamask-improvement-proposals/blob/main/MIPs/mip-2.md
  ///
  /// If the current wallet does not support this standard, it will throw an error. Then you should implement your custom disconnection logic
  Future<void> revokePermissions() async {
    final requestObject = JSObject().getEthereumRequestObject(EthereumRequest.revokePermissions.method, [
      {
        "eth_accounts": JSObject(), // empty object
      }
    ]);

    await jsEthereumProvider.request(requestObject).toDart;
  }

  @override
  List<Object?> get props => [jsEthereumProvider];
}
