import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/enums/ethereum_event.dart";
import "package:web3kit/src/enums/ethereum_request.dart";
import "package:web3kit/src/extensions/js_object_extension.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_unsafe_mock.dart";

import "../mocks.dart";

void main() {
  late CustomJSEthereumProviderMock jsEthereumProvider;
  late EthereumProvider sut;

  setUp(() {
    jsEthereumProvider = CustomJSEthereumProviderMock();

    sut = EthereumProvider(jsEthereumProvider);

    registerFallbackValue(JSObject());
  });

  test(
      "When calling `onAccountsChanged` it should register an event listener in the JS implementation for the `accountsChanged` event",
      () async {
    List<String> callbackReceivedAccounts = [];
    final accounts = [const JSString("0x123"), const JSString("0x456"), const JSString("0x789")];
    final callback = ((List<String> accounts) => callbackReceivedAccounts = accounts);

    sut.onAccountsChanged(callback);

    jsEthereumProvider.callRegisteredEvent(EthereumEvent.accountsChanged.name, JSArray<JSString>(accounts));

    expect(callbackReceivedAccounts, ["0x123", "0x456", "0x789"]);
  });

  test("When calling `revokePermissions` it should emit an request to the JS implementation", () async {
    final jsEthereumProvider0 = JSEthereumProviderMock();
    final sut0 = EthereumProvider(jsEthereumProvider0);

    when(() => jsEthereumProvider0.request(any())).thenAnswer((_) => JSPromise<JSAny>(const JSString("")));

    sut0.revokePermissions();

    verify(() => jsEthereumProvider0.request(any())).called(1);
  });

  test("When calling `revokePermissions` it should use the correct params in the request", () async {
    final expectedRequestObject = JSObject().getEthereumRequestObject(EthereumRequest.revokePermissions.method, [
      {
        "eth_accounts": JSObject(),
      }
    ]);

    sut.revokePermissions();

    expect(jsEthereumProvider.lastRequestObject, expectedRequestObject);
  });

  test("When calling `switchChain` it should emit an request to the JS implementation", () async {
    final jsEthereumProvider0 = JSEthereumProviderMock();
    final sut0 = EthereumProvider(jsEthereumProvider0);

    when(() => jsEthereumProvider0.request(any())).thenAnswer((_) => JSPromise<JSAny>(const JSString("")));

    await sut0.switchChain("0x1");

    verify(() => jsEthereumProvider0.request(any())).called(1);
  });

  test("When calling `switchChain` it should use the correct extension and params in the request", () async {
    const String hexChainId = "0x1";

    final expectedParams = JSObject().getEthereumRequestObject(EthereumRequest.switchEthereumChain.method, [
      {
        "chainId": hexChainId.toJS,
      }
    ]);

    await sut.switchChain(hexChainId);

    expect(jsEthereumProvider.lastRequestObject, expectedParams);
  });

  test("When calling `addChain`, it should assert that the rpc list is not null", () async {
    final jsEthereumProvider0 = JSEthereumProviderMock();
    final sut0 = EthereumProvider(jsEthereumProvider0);

    expect(
      () async => await sut0.addChain(const ChainInfo(hexChainId: "0x1", rpcUrls: null)),
      throwsAssertionError,
    );
  });

  test("When calling `addChain`, it should assert that the rpc list is not empty", () async {
    final jsEthereumProvider0 = JSEthereumProviderMock();
    final sut0 = EthereumProvider(jsEthereumProvider0);

    expect(
      () async => await sut0.addChain(const ChainInfo(hexChainId: "0x1", rpcUrls: [])),
      throwsAssertionError,
    );
  });

  test("When calling `addChain`, it should assert that the native currency is not null", () async {
    final jsEthereumProvider0 = JSEthereumProviderMock();
    final sut0 = EthereumProvider(jsEthereumProvider0);

    expect(
      () async => await sut0.addChain(
        const ChainInfo(hexChainId: "0x1", rpcUrls: ["http://rpc.io"], nativeCurrency: null),
      ),
      throwsAssertionError,
    );
  });

  test("When calling `addChain` it should emit an request to the JS implementation", () async {
    final jsEthereumProvider0 = JSEthereumProviderMock();
    final sut0 = EthereumProvider(jsEthereumProvider0);

    when(() => jsEthereumProvider0.request(any())).thenAnswer((_) => JSPromise<JSAny>(const JSString("")));

    await sut0.addChain(
      const ChainInfo(
        hexChainId: "0x1",
        rpcUrls: ["http://rpc.io"],
        nativeCurrency: NativeCurrency(name: "", decimals: 1, symbol: ""),
      ),
    );

    verify(() => jsEthereumProvider0.request(any())).called(1);
  });

  test("When calling `addChain` it should send the correct params in the request to JS", () async {
    const networkInfo = ChainInfo(
      hexChainId: "0x1",
      rpcUrls: ["http://rpc.io"],
      nativeCurrency: NativeCurrency(name: "ETH", decimals: 1, symbol: "ETH"),
      blockExplorerUrls: ["https://etherscan.io"],
      chainName: "Ethereum",
      iconsURLs: ["https://etherscan.io/images/ethereum.png"],
    );

    final expectedRequestObject = JSObject().getEthereumRequestObject(EthereumRequest.addEthereumChain.method, [
      {
        "chainId": networkInfo.hexChainId.toJS,
        "chainName": networkInfo.chainName!.toJS,
        "rpcUrls": networkInfo.rpcUrls!.jsify(),
        "iconUrls": networkInfo.iconsURLs!.jsify(),
        "nativeCurrency": JSObject()
          ..setProperty("name".toJS, networkInfo.nativeCurrency!.name.toJS)
          ..setProperty("symbol".toJS, networkInfo.nativeCurrency!.symbol.toJS)
          ..setProperty("decimals".toJS, networkInfo.nativeCurrency!.decimals.toJS),
        "blockExplorerUrls": networkInfo.blockExplorerUrls!.jsify(),
      }
    ]);

    await sut.addChain(networkInfo);

    expect(jsEthereumProvider.lastRequestObject, expectedRequestObject);
  });

  test("When calling `addChain` it should not include chain name parameter if not provided", () async {
    const networkInfo = ChainInfo(
      hexChainId: "0x1",
      rpcUrls: ["http://rpc.io"],
      nativeCurrency: NativeCurrency(name: "ETH", decimals: 1, symbol: "ETH"),
      blockExplorerUrls: ["https://etherscan.io"],
      chainName: null,
      iconsURLs: ["https://etherscan.io/images/ethereum.png"],
    );

    final expectedRequestObject = JSObject().getEthereumRequestObject(EthereumRequest.addEthereumChain.method, [
      {
        "chainId": networkInfo.hexChainId.toJS,
        "rpcUrls": networkInfo.rpcUrls!.jsify(),
        "iconUrls": networkInfo.iconsURLs!.jsify(),
        "nativeCurrency": JSObject()
          ..setProperty("name".toJS, networkInfo.nativeCurrency!.name.toJS)
          ..setProperty("symbol".toJS, networkInfo.nativeCurrency!.symbol.toJS)
          ..setProperty("decimals".toJS, networkInfo.nativeCurrency!.decimals.toJS),
        "blockExplorerUrls": networkInfo.blockExplorerUrls!.jsify(),
      }
    ]);

    await sut.addChain(networkInfo);

    expect(jsEthereumProvider.lastRequestObject, expectedRequestObject);
  });

  test("When calling `addChain` it should not include icon urls parameter if not provided", () async {
    const networkInfo = ChainInfo(
      hexChainId: "0x1",
      rpcUrls: ["http://rpc.io"],
      nativeCurrency: NativeCurrency(name: "ETH", decimals: 1, symbol: "ETH"),
      blockExplorerUrls: ["https://etherscan.io"],
      chainName: "Ethereum",
      iconsURLs: null,
    );

    final expectedRequestObject = JSObject().getEthereumRequestObject(EthereumRequest.addEthereumChain.method, [
      {
        "chainId": networkInfo.hexChainId.toJS,
        "rpcUrls": networkInfo.rpcUrls!.jsify(),
        "chainName": networkInfo.chainName!.toJS,
        "nativeCurrency": JSObject()
          ..setProperty("name".toJS, networkInfo.nativeCurrency!.name.toJS)
          ..setProperty("symbol".toJS, networkInfo.nativeCurrency!.symbol.toJS)
          ..setProperty("decimals".toJS, networkInfo.nativeCurrency!.decimals.toJS),
        "blockExplorerUrls": networkInfo.blockExplorerUrls!.jsify(),
      }
    ]);

    await sut.addChain(networkInfo);

    expect(jsEthereumProvider.lastRequestObject, expectedRequestObject);
  });

  test("When calling `addChain` it should not include block explorer urls parameter if not provided", () async {
    const networkInfo = ChainInfo(
      hexChainId: "0x1",
      rpcUrls: ["http://rpc.io"],
      nativeCurrency: NativeCurrency(name: "ETH", decimals: 1, symbol: "ETH"),
      blockExplorerUrls: null,
      chainName: "Ethereum",
      iconsURLs: ["https://etherscan.io/images/ethereum.png"],
    );

    final expectedRequestObject = JSObject().getEthereumRequestObject(EthereumRequest.addEthereumChain.method, [
      {
        "chainId": networkInfo.hexChainId.toJS,
        "rpcUrls": networkInfo.rpcUrls!.jsify(),
        "chainName": networkInfo.chainName!.toJS,
        "iconUrls": networkInfo.iconsURLs!.jsify(),
        "nativeCurrency": JSObject()
          ..setProperty("name".toJS, networkInfo.nativeCurrency!.name.toJS)
          ..setProperty("symbol".toJS, networkInfo.nativeCurrency!.symbol.toJS)
          ..setProperty("decimals".toJS, networkInfo.nativeCurrency!.decimals.toJS),
      }
    ]);

    await sut.addChain(networkInfo);

    expect(jsEthereumProvider.lastRequestObject, expectedRequestObject);
  });

  test(
      "When calling `addChain` it should not include block explorer urls, chain name and icon urls parameters if not provided",
      () async {
    const networkInfo = ChainInfo(
      hexChainId: "0x1",
      rpcUrls: ["http://rpc.io"],
      nativeCurrency: NativeCurrency(name: "ETH", decimals: 1, symbol: "ETH"),
      blockExplorerUrls: null,
      chainName: null,
      iconsURLs: null,
    );

    final expectedRequestObject = JSObject().getEthereumRequestObject(EthereumRequest.addEthereumChain.method, [
      {
        "chainId": networkInfo.hexChainId.toJS,
        "rpcUrls": networkInfo.rpcUrls!.jsify(),
        "nativeCurrency": JSObject()
          ..setProperty("name".toJS, networkInfo.nativeCurrency!.name.toJS)
          ..setProperty("symbol".toJS, networkInfo.nativeCurrency!.symbol.toJS)
          ..setProperty("decimals".toJS, networkInfo.nativeCurrency!.decimals.toJS),
      }
    ]);

    await sut.addChain(networkInfo);

    expect(jsEthereumProvider.lastRequestObject, expectedRequestObject);
  });
}
