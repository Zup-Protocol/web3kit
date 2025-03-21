import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/core/exceptions/ethereum_request_exceptions.dart";
import "package:web3kit/core/exceptions/ethers_exceptions.dart";
import "package:web3kit/src/abis/erc_20.abi.g.dart";
import "package:web3kit/src/cache.dart";
import "package:web3kit/src/enums/eip_6963_event_enum.dart";
import "package:web3kit/src/enums/ethereum_event.dart";
import "package:web3kit/src/enums/ethereum_request_error.dart";
import "package:web3kit/src/enums/ethers_error_code.dart";
import "package:web3kit/src/inject.dart";
import "package:web3kit/src/mocks/eip_6963_detail.js_mock.dart";
import "package:web3kit/src/mocks/eip_6963_detail_info.js_mock.dart";
import "package:web3kit/src/mocks/eip_6963_event.js_mock.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart";
import "package:web3kit/src/mocks/ethereum_request_error.js_mock.dart";
import "package:web3kit/src/mocks/ethers_errors.js_mock.dart";
import "package:web3kit/src/mocks/ethers_json_rpc_provider.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart" hide Cache;

import "../mocks.dart";

class _CustomWindowMock extends Window {
  JSFunction? lastCallbackSet;

  @override
  void addEventListener(String eventName, JSFunction callback) {
    lastCallbackSet = callback;
  }

  @override
  void dispatchEvent(Event event) {
    if (event.type.toDart == EIP6963EventEnum.requestProvider.name) {
      lastCallbackSet!.dartFunction.call(event);
    }
  }
}

void main() {
  late BrowserProvider browserProvider;
  late Cache cache;
  late Window window;
  late Wallet sut;
  late Erc20 erc20;
  late Signer signer;

  setUp(() {
    browserProvider = BrowserProviderMock();
    cache = CacheMock();
    window = _CustomWindowMock();
    erc20 = Erc20Mock();
    signer = SignerMock();

    sut = Wallet(browserProvider, cache, window, erc20);

    registerFallbackValue(JSFunction(() {}));
    registerFallbackValue(const JSString(""));
    registerFallbackValue(EthereumProviderMock());
    registerFallbackValue(const ChainInfo(hexChainId: ""));
    registerFallbackValue(signer);

    mockInjections(customBrowserProvider: browserProvider, customWallet: sut);

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async => () {});
    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer);
    when(() => signer.address).thenAnswer((_) async => "0x99E3CfADCD8Feecb5DdF91f88998cFfB3145F78c");
  });

  tearDown(() => resetInjections());

  test("When instantiating the Wallet object, it should get the list of installed wallets in the browser", () {
    const walletsAmount = 5;
    final provider = EthereumProviderMock();

    when(() => provider.jsEthereumProvider).thenReturn(JSEthereumProviderMock());

    for (var i = 1; i < walletsAmount; i++) {
      window.dispatchEvent(JSEIP6963Event(
        JSString(EIP6963EventEnum.requestProvider.name),
        JSEIP6963Detail(
          JSEIP6963DetailInfo(
            JSString("Wallet ${i + 1}"),
            JSString("Wallet ${i + 1} icon"),
            JSString("Wallet ${i + 1} rdns"),
          ),
        ),
      ));
    }

    expect(sut.installedWallets.length, walletsAmount);
    expect(sut.installedWallets.last.info.name, "Wallet 5");
  });

  group("""After the Wallet object is instantiated,
   the signer stream should be set, listening for 
   the accountsChanged event""", () {
    test("It should listen for the accountsChanged event for all installed wallets", () async {
      const walletsAmount = 5;
      final List<CustomJSEthereumProviderMock> providers =
          List.generate(walletsAmount, (_) => CustomJSEthereumProviderMock());
      final window0 = Window();

      for (var i = 0; i < walletsAmount; i++) {
        window0.setAddEventListenerCallbackParam(JSEIP6963Event(
          JSString(EIP6963EventEnum.requestProvider.name),
          JSEIP6963Detail(
            JSEIP6963DetailInfo(
              JSString("Wallet ${i + 1}"),
              JSString("Wallet ${i + 1} icon"),
              JSString("Wallet ${i + 1} rdns"),
            ),
            providers[i],
          ),
        ));
      }

      final wallet = Wallet(browserProvider, cache, window0, erc20);

      expectLater(wallet.signerStream, emitsInOrder(List.generate(walletsAmount, (index) => anything)));

      for (var i = 0; i < walletsAmount; i++) {
        final signer = SignerMock();
        when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer);
        when(() => signer.address).thenAnswer((_) async => i.toString());

        await providers[i].callRegisteredEvent(
          EthereumEvent.accountsChanged.name,
          JSArray<JSString>([i.toString().toJS]),
        );
      }
    });

    test("""If the accountsChanged array callback is empty,
    and has a current connected signer, it should emit a
    null event and set the connected provider to null""", () async {
      const currentConnectedSignerAddress = "0x36591DeBffCf727D5EEA2Cd6A745ee905Fae91C8";

      final provider = CustomJSEthereumProviderMock();
      final window0 = Window();

      window0.setAddEventListenerCallbackParam(JSEIP6963Event(
        JSString(EIP6963EventEnum.requestProvider.name),
        JSEIP6963Detail(
          const JSEIP6963DetailInfo(
            JSString("Wallet 1"),
            JSString("Wallet 1 icon"),
            JSString("Wallet 1 rdns"),
          ),
          provider,
        ),
      ));

      final wallet = Wallet(browserProvider, cache, window0, erc20);
      await provider.callRegisteredEvent(
          EthereumEvent.accountsChanged.name, <JSString>[currentConnectedSignerAddress.toJS].jsify());

      await Future.delayed(Duration.zero); // we need this to wait until the connected provider is set to null

      expectLater(wallet.signerStream, emits(null));

      await provider.callRegisteredEvent(EthereumEvent.accountsChanged.name, const JSArray<JSString>([]));

      await Future.delayed(Duration.zero); // we need this to wait until the connected provider is set to null

      expect(wallet.connectedProvider, null);
    });

    test("""If the accountsChanged array callback is not empty,
    and does not have a current connected signer, it should emit an
    event with the new connected signer and set the connected provider""", () async {
      final signer = SignerMock();
      final provider = CustomJSEthereumProviderMock();
      final window0 = Window();
      const signerAddress = "0x36591DeBffCf727D5EEA2Cd6A745ee905Fae91C8";

      when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer);
      when(() => signer.address).thenAnswer((_) async => signerAddress);

      window0.setAddEventListenerCallbackParam(JSEIP6963Event(
        JSString(EIP6963EventEnum.requestProvider.name),
        JSEIP6963Detail(
          const JSEIP6963DetailInfo(
            JSString("Wallet 1"),
            JSString("Wallet 1 icon"),
            JSString("Wallet 1 rdns"),
          ),
          provider,
        ),
      ));

      final wallet = Wallet(browserProvider, cache, window0, erc20);

      expectLater(wallet.signerStream, emits(signer));

      await provider.callRegisteredEvent(EthereumEvent.accountsChanged.name, <JSString>[signerAddress.toJS].jsify());

      expect(wallet.connectedProvider?.jsEthereumProvider, provider);
    });

    test("""If the accountsChanged array callback is not empty,
    and we have a current connected signer, it should emit an
    event with the new connected signer and set the new connected provider""", () async {
      final signer1 = SignerMock();
      final signer2 = SignerMock();
      final provider1 = CustomJSEthereumProviderMock();
      final provider2 = CustomJSEthereumProviderMock();
      final window0 = Window();
      const signerAddress1 = "0x36591DeBffCf727D5EEA2Cd6A745ee905Fae91C8";
      const signerAddress2 = "0x99E3CfADCD8Feecb5DdF91f88998cFfB3145F78c";

      window0.setAddEventListenerCallbackParam(JSEIP6963Event(
        JSString(EIP6963EventEnum.requestProvider.name),
        JSEIP6963Detail(
          const JSEIP6963DetailInfo(
            JSString("Wallet 1"),
            JSString("Wallet 1 icon"),
            JSString("Wallet 1 rdns"),
          ),
          provider1,
        ),
      ));

      window0.setAddEventListenerCallbackParam(JSEIP6963Event(
        JSString(EIP6963EventEnum.requestProvider.name),
        JSEIP6963Detail(
          const JSEIP6963DetailInfo(
            JSString("Wallet 1"),
            JSString("Wallet 1 icon"),
            JSString("Wallet 1 rdns"),
          ),
          provider2,
        ),
      ));

      final wallet = Wallet(browserProvider, cache, window0, erc20);
      expectLater(wallet.signerStream, emitsInOrder([signer1, signer2]));

      when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer1);
      when(() => signer1.address).thenAnswer((_) async => signerAddress1);
      await provider1.callRegisteredEvent(EthereumEvent.accountsChanged.name, <JSString>[signerAddress1.toJS].jsify());

      when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer2);
      when(() => signer2.address).thenAnswer((_) async => signerAddress2);
      await provider2.callRegisteredEvent(EthereumEvent.accountsChanged.name, <JSString>[signerAddress2.toJS].jsify());

      expect(wallet.connectedProvider?.jsEthereumProvider, provider2);
    });
  });

  test("When calling `connectCachedWallet` and there is no cached connection, it should not try to connect", () async {
    when(() => cache.getConnectedWallet()).thenAnswer((_) async => null);
    await sut.connectCachedWallet();

    verifyNever(() => browserProvider.getSigner(any()));
    expect(sut.connectedProvider, null);
  });

  test(
      "When calling `connectCachedWallet` and it returns a cached wallet, but the installed wallet RDNS is different, it should not connect",
      () async {
    const cachedWalletRDNS = "com.rdns";
    const installedWalletRDNS = "com.rdns.not.installed";
    when(() => cache.getConnectedWallet()).thenAnswer((_) async => cachedWalletRDNS);

    window.dispatchEvent(JSEIP6963Event(
      JSString(EIP6963EventEnum.requestProvider.name),
      JSEIP6963Detail(
        const JSEIP6963DetailInfo(
          JSString("Wallet 1"),
          JSString("Wallet 1 icon"),
          JSString(installedWalletRDNS),
        ),
        CustomJSEthereumProviderMock(),
      ),
    ));

    await sut.connectCachedWallet();

    assert(sut.installedWallets.every((w) => w.info.rdns != cachedWalletRDNS));

    verifyNever(() => browserProvider.getSigner(any()));
    expect(sut.connectedProvider, null);
  });

  test(
      "When calling `connectCachedWallet`, it returns a cached wallet, and it has the installed wallet, it should connect",
      () async {
    const walletRDNS = "com.rdns";
    final provider = JSEthereumProviderMock();
    final jsEthersSigner = JSEthersSignerMock();
    final signer = Signer(jsEthersSigner, JSEthersBrowserProviderMock());

    when(() => cache.getConnectedWallet()).thenAnswer((_) async => walletRDNS);
    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer);
    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));

    window.dispatchEvent(JSEIP6963Event(
      JSString(EIP6963EventEnum.requestProvider.name),
      JSEIP6963Detail(
        const JSEIP6963DetailInfo(
          JSString("Wallet 1"),
          JSString("Wallet 1 icon"),
          JSString(walletRDNS),
        ),
        provider,
      ),
    ));

    await sut.connectCachedWallet();

    verify(() => browserProvider.getSigner(any())).called(1);
    expect(sut.connectedProvider?.jsEthereumProvider, provider);
  });

  test(
      "When calling `connect` it should call `getSigner` from browser provider with the wallet provider, to prompt the connect wallet dialog",
      () async {
    final jsEthersSigner = JSEthersSignerMock();
    final signer = Signer(jsEthersSigner, JSEthersBrowserProviderMock());
    final ethereumProvider = EthereumProviderMock();
    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer);
    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));

    await sut.connect(walletToConnect);

    verify(() => browserProvider.getSigner(ethereumProvider)).called(1);
  });

  test("When calling `connect` it should set the connected provider with the wallet provider", () async {
    final jsEthersSigner = JSEthersSignerMock();
    final signer = Signer(jsEthersSigner, JSEthersBrowserProviderMock());

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer);
    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));

    final ethereumProvider = EthereumProviderMock();
    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    await sut.connect(walletToConnect);

    expect(sut.connectedProvider, ethereumProvider);
  });

  test(
      "When calling `connect` and the `getSigner` from browser provider returns an error, it should not set the connected provider",
      () async {
    const error = "err";
    final ethereumProvider = EthereumProviderMock();
    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenThrow(error);

    try {
      await sut.connect(walletToConnect);
    } catch (e) {
      if (e != error) rethrow;
    }

    expect(sut.connectedProvider, null);
  });

  test("When calling `connect` it should notify the signer change stream", () async {
    final ethereumProvider = EthereumProviderMock();
    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);
    final jsEthersSigner = JSEthersSignerMock();
    final signer = Signer(jsEthersSigner, JSEthersBrowserProviderMock());

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer);
    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));

    expectLater(sut.signerStream, emits(signer));

    await sut.connect(walletToConnect);
  });

  test(
      "When calling `connect` and the `getSigner` from browser provider returns an error, it should not notify the signer change stream",
      () async {
    const error = "err";
    final ethereumProvider = EthereumProviderMock();
    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenThrow(error);

    expectLater(
        sut.signerStream.timeout(
          const Duration(milliseconds: 100),
          onTimeout: (sink) => sink.close(),
        ),
        neverEmits(anything));

    try {
      await sut.connect(walletToConnect);
    } catch (e) {
      if (e != error) rethrow;
    }
  });

  test("When calling `connect` it should save the current wallet rdns in the cache", () async {
    final ethereumProvider = EthereumProviderMock();
    const walletRDNS = "rdns.wallet";
    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: walletRDNS), provider: ethereumProvider);
    final jsEthersSigner = JSEthersSignerMock();
    final signer = Signer(jsEthersSigner, JSEthersBrowserProviderMock());

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer);
    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));

    await sut.connect(walletToConnect);

    verify(() => cache.setWalletConnectionState(walletRDNS)).called(1);
  });

  test("""When calling `connect` and the `getSigner`
      from browser provider returns an error, it should not
      save the current wallet rdns in the cache""", () async {
    const error = "err";
    const walletRDNS = "rdns.wallet";
    final ethereumProvider = EthereumProviderMock();
    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: walletRDNS), provider: ethereumProvider);

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenThrow(error);

    try {
      await sut.connect(walletToConnect);
    } catch (e) {
      if (e != error) rethrow;
    }

    verifyNever(() => cache.setWalletConnectionState(walletRDNS));
  });

  test("When calling `connect` it should return the signer from browser provider", () async {
    final ethereumProvider = EthereumProviderMock();
    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);
    final jsEthersSigner = JSEthersSignerMock();
    final expectedSigner = Signer(jsEthersSigner, JSEthersBrowserProviderMock());

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => expectedSigner);
    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));

    final signerReturned = await sut.connect(walletToConnect);

    expect(signerReturned, expectedSigner);
  });

  test("When calling `connect` and the user rejects the connection, it should throw a custom error", () async {
    final ethereumProvider = EthereumProviderMock();
    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    final error = JSEthersError(EthersError.actionRejected.code.toJS);

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenThrow(error);

    expect(() async => await sut.connect(walletToConnect), throwsA(isA<UserRejectedAction>()));
  });

  test("When calling `connect` and throw an error that is not the user rejection, it should rethrow the error",
      () async {
    final ethereumProvider = EthereumProviderMock();

    final walletToConnect =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    const error = "error";

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenThrow(error);

    expect(() async => await sut.connect(walletToConnect), throwsA(error));
  });

  test("When calling `disconnect` it should emit a signer changed event with null", () async {
    final walletDetails = WalletDetail(
      info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"),
      provider: EthereumProviderMock(),
    );
    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});

    await sut.connect(walletDetails);

    await Future.delayed(const Duration(seconds: 0)); // needed to not cause concurrency issues

    expectLater(sut.signerStream, emits(null));

    await sut.disconnect();
  });

  test("When calling `disconnect` it should save the current wallet as null in the cache", () async {
    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});

    await sut.disconnect();

    verify(() => cache.setWalletConnectionState(null)).called(1);
  });

  test("When calling `disconnect` the revoke permission function to the wallet provider should be called", () async {
    final provider = EthereumProviderMock();
    final wallet = WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: provider);

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => provider.revokePermissions()).thenAnswer((_) async {});

    await sut.connect(wallet); // setting the provider
    await sut.disconnect();

    verify(() => provider.revokePermissions()).called(1);
  });

  test("When calling `disconnect` and the revoke permission call to the wallet provider throw, it should not throw",
      () async {
    final provider = EthereumProviderMock();
    final wallet = WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: provider);

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => provider.revokePermissions()).thenThrow("it should not rethrow");

    await sut.connect(wallet); // setting the provider

    await sut.disconnect(); // if it throws, the test will fail
  });

  test("When calling `signer` it should return the current connected signer", () async {
    final provider = EthereumProviderMock();
    final wallet = WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: provider);
    final expectedSigner = SignerMock();
    const expectedSignerAddress = "expectedSignerAddress";

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => expectedSigner);
    when(() => expectedSigner.address).thenAnswer((_) async => expectedSignerAddress);

    await sut.connect(wallet);

    await Future.delayed(const Duration(seconds: 0)); // needed to not cause concurrency issues

    expect(await sut.signer?.address, expectedSignerAddress);
  });

  test("When calling `signer` after the signer has changed it should return the new signer", () async {
    final provider = EthereumProviderMock();
    final oldWallet = WalletDetail(info: const WalletInfo(name: "old", icon: "old", rdns: "old"), provider: provider);
    final newWallet = WalletDetail(info: const WalletInfo(name: "new", icon: "new", rdns: "new"), provider: provider);
    final oldSigner = SignerMock();
    final newSigner = SignerMock();
    const oldSignerAddress = "oldSignerAddress";
    const newSignerAddress = "newSignerAddress";

    when(() => cache.setWalletConnectionState(any())).thenAnswer((_) async {});
    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => oldSigner);
    when(() => oldSigner.address).thenAnswer((_) async => oldSignerAddress);

    await sut.connect(oldWallet);

    await Future.delayed(const Duration(seconds: 0)); // needed to not cause concurrency issues

    expect(await sut.signer?.address, oldSignerAddress); // making sure the signer is the old before the new

    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => newSigner);
    when(() => newSigner.address).thenAnswer((_) async => newSignerAddress);

    await sut.connect(newWallet);

    await Future.delayed(const Duration(seconds: 0)); // needed to not cause concurrency issues

    expect(await sut.signer?.address, newSignerAddress);
  });

  test("When calling `shared` it should return the wallet instance", () async {
    Inject.getInjections();

    expect(Wallet.shared.hashCode, sut.hashCode);
  });

  test("when calling `switchNetwork` and the current connected provider is null, it should throw", () async {
    expect(() async => await sut.switchNetwork("0x1"), throwsAssertionError);
  });

  test("When calling `switchNetwork` it should call the provider's `switchChain` method", () async {
    const chainId = "0x1";
    final ethereumProvider = EthereumProviderMock();
    final walletDetail =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    when(() => ethereumProvider.switchChain(any())).thenAnswer((_) async => () {});

    await sut.connect(walletDetail);

    await sut.switchNetwork(chainId);

    verify(() => ethereumProvider.switchChain(chainId)).called(1);
  });

  test("When calling `switchNetwork` it should get a the new signer and update it", () async {
    const chainId = "0x1";
    final ethereumProvider = EthereumProviderMock();
    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"),
      provider: ethereumProvider,
    );

    final newSigner = SignerMock();

    when(() => ethereumProvider.switchChain(any())).thenAnswer((_) async => () {});

    await sut.connect(walletDetail);

    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => newSigner);

    /// note that the test will not fail if this is not emitted, but instead it will wait forever until timeout
    expectLater(sut.signerStream, emits(newSigner));

    await sut.switchNetwork(chainId);

    verify(() => browserProvider.getSigner(ethereumProvider)).called(2); // 1 of the connect and 1 of the switch
  });

  test(
      "When calling `switchNetwork` and the provider throw an error that the chain is not supported, it should throw an custom error",
      () async {
    const chainId = "0x1";
    final ethereumProvider = EthereumProviderMock();
    final walletDetail =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    when(() => ethereumProvider.switchChain(any())).thenThrow(JSEthereumRequestError(4902.toJS));

    await sut.connect(walletDetail);

    expect(() async => await sut.switchNetwork(chainId), throwsA(isA<UnrecognizedChainId>()));
  });

  test(
      "When calling `switchNetwork` and the provider throw any error other than the chain is not supported, it should rethrow the error",
      () async {
    const chainId = "0x1";
    final ethereumProvider = EthereumProviderMock();
    final walletDetail =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    when(() => ethereumProvider.switchChain(any())).thenThrow(JSEthereumRequestError(123.toJS));

    await sut.connect(walletDetail);

    expect(() async => await sut.switchNetwork(chainId), throwsA(isA<JSEthereumRequestError>()));
  });

  test(
      "When calling `switchNetwork` and a error that is not an [JSEthereumRequestError] occur, it should rethrow the error",
      () async {
    const chainId = "0x1";
    const randomError = "ERROR_RANDOM";
    final ethereumProvider = EthereumProviderMock();
    final walletDetail =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    when(() => ethereumProvider.switchChain(any())).thenThrow(randomError);

    await sut.connect(walletDetail);

    expect(() async => await sut.switchNetwork(chainId), throwsA(randomError));
  });

  test("when calling `addNetwork` without a connected provider, it should throw an assertion error", () async {
    expect(() async => await sut.addNetwork(const ChainInfo(hexChainId: "as")), throwsAssertionError);
  });

  test("When calling `addNetwork` it should call the provider's `addChain` method", () async {
    const chainId = "0x1";
    final ethereumProvider = EthereumProviderMock();
    final walletDetail =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);
    const chainInfo = ChainInfo(hexChainId: chainId);

    when(() => ethereumProvider.addChain(any())).thenAnswer((_) async => () {});

    await sut.connect(walletDetail);
    await sut.addNetwork(chainInfo);

    verify(() => ethereumProvider.addChain(chainInfo)).called(1);
  });

  test("""When calling `switchOrAddNetwork` it should call the provider's `switchChain` method.
  if an error is thrown saying that the chain is not added yet in the wallet,
  it should call the provider's `addChain` method""", () async {
    final ethereumProvider = EthereumProviderMock();
    final walletDetail =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    when(() => ethereumProvider.switchChain(any())).thenThrow(JSEthereumRequestError(4902.toJS));
    when(() => ethereumProvider.addChain(any())).thenAnswer((_) async => () {});

    const ChainInfo network = ChainInfo(hexChainId: "0x1");

    await sut.connect(walletDetail);

    await sut.switchOrAddNetwork(network);

    verify(() => ethereumProvider.addChain(network)).called(1);
  });

  test("When calling `connectedNetwork`, it should assert for a connected provider", () {
    expect(() async => await sut.connectedNetwork, throwsAssertionError);
  });

  test("When calling `connectedNetwork`, it should ask for the browser provider to get the connected network",
      () async {
    const connectedNetwork = ChainInfo(hexChainId: "0x1");
    final ethereumProvider = EthereumProviderMock();
    final walletDetail =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    when(() => browserProvider.getNetwork(any())).thenAnswer((_) async => connectedNetwork);

    await sut.connect(walletDetail);

    expect(await sut.connectedNetwork, connectedNetwork);
  });

  test("When calling `tokenBalance` but there's no connected signer, it should assert", () {
    expect(() async => await sut.tokenBalance("0x1"), throwsAssertionError);
  });

  test("When calling `tokenBalance` with a rpc url, it should use the rpc url to make the request", () async {
    final ethereumProvider = EthereumProviderMock();
    final erc20Impl = Erc20ImplMock();
    const tokenAddress = "0x1";
    const rpcUrl = "https://dale.com";

    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"),
      provider: ethereumProvider,
    );

    when(() => erc20.fromRpcProvider(contractAddress: any(named: "contractAddress"), rpcUrl: any(named: "rpcUrl")))
        .thenReturn(erc20Impl);
    when(() => erc20Impl.decimals()).thenAnswer((_) async => BigInt.one);
    when(() => erc20Impl.balanceOf(account: any(named: "account"))).thenAnswer((_) async => BigInt.one);

    await sut.connect(walletDetail);

    await sut.tokenBalance(
      tokenAddress,
      rpcUrl: rpcUrl,
    );

    verify(
      () => erc20.fromRpcProvider(
        contractAddress: tokenAddress,
        rpcUrl: rpcUrl,
      ),
    );

    verifyNever(() => erc20.fromSigner(contractAddress: any(named: "contractAddress"), signer: any(named: "signer")));
  });

  test("When calling `tokenBalance` without a rpc url, it should use the signer provider to make the request",
      () async {
    final ethereumProvider = EthereumProviderMock();
    final erc20Impl = Erc20ImplMock();
    const tokenAddress = "0x1";

    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"),
      provider: ethereumProvider,
    );

    when(() => erc20.fromSigner(contractAddress: tokenAddress, signer: signer)).thenReturn(erc20Impl);
    when(() => erc20Impl.decimals()).thenAnswer((_) async => BigInt.one);
    when(() => erc20Impl.balanceOf(account: any(named: "account"))).thenAnswer((_) async => BigInt.one);

    await sut.connect(walletDetail);

    await sut.tokenBalance(tokenAddress);

    verify(
      () => erc20.fromSigner(
        contractAddress: tokenAddress,
        signer: signer,
      ),
    );

    verifyNever(
      () => erc20.fromRpcProvider(contractAddress: any(named: "contractAddress"), rpcUrl: any(named: "rpcUrl")),
    );
  });

  test(
      "When calling `tokenBalance` it should return the wallet balance parsed with the common decimals (not 1200000000 instead of 1.2)",
      () async {
    final ethereumProvider = EthereumProviderMock();
    final erc20Impl = Erc20ImplMock();
    const tokenAddress = "0x1";
    final tokenBalance = BigInt.from(150000000000000000); // 0.15 * 10^(decimals)
    final tokenDecimals = BigInt.from(18);
    const tokenBalanceFormatted = 0.15;

    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"),
      provider: ethereumProvider,
    );

    when(() => erc20.fromSigner(contractAddress: tokenAddress, signer: signer)).thenReturn(erc20Impl);
    when(() => erc20Impl.balanceOf(account: any(named: "account"))).thenAnswer((_) async => tokenBalance);
    when(() => erc20Impl.decimals()).thenAnswer((_) async => tokenDecimals);

    await sut.connect(walletDetail);

    expect(await sut.tokenBalance(tokenAddress), tokenBalanceFormatted);
  });

  test("After connecting a wallet, the `connectedWallet` getter should return the connected wallet detail", () async {
    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "name.com", icon: "icon.ico", rdns: "rdns.io"),
      provider: EthereumProviderMock(),
    );

    await sut.connect(walletDetail);

    expect(sut.connectedWallet, walletDetail);
  });

  test(
    """When an error is thrown while `switchNetwork` is being called, the current connected wallet
    is Rabby and the error is a Rabby request error, with the code of unrecognized chain id,
    it should throw an [UnrecognizedChainId] error"",
    """,
    () async {
      final connectedProvider = EthereumProviderMock();
      final jsRabbyRequestError = JSRabbyRequestErrorMock();
      final jsRabbyRequestErrorData = JSRabbyRequestErrorDataMock();

      const rabbyRnds = "io.rabby";

      final walletDetail = WalletDetail(
        info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: rabbyRnds),
        provider: connectedProvider,
      );

      when(() => connectedProvider.switchChain(any())).thenThrow(jsRabbyRequestError);
      when(() => jsRabbyRequestError.data).thenReturn(jsRabbyRequestErrorData);
      when(() => jsRabbyRequestErrorData.originalError).thenReturn(JSEthereumRequestError(
        EthereumRequestError.unrecognizedChainId.code.toJS,
      ));

      await sut.connect(walletDetail);

      expect(() => sut.switchNetwork("0x1"), throwsA(isA<UnrecognizedChainId>()));
    },
  );

  test(
    """When an error is thrown while `switchNetwork` is being called, the current connected wallet
    is Rabby and the error is a Rabby request error, with the code not being of unrecognized chain id,
    it should rethrow the error"",
    """,
    () async {
      final connectedProvider = EthereumProviderMock();
      final jsRabbyRequestError = JSRabbyRequestErrorMock();
      final jsRabbyRequestErrorData = JSRabbyRequestErrorDataMock();

      const rabbyRnds = "io.rabby";

      final walletDetail = WalletDetail(
        info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: rabbyRnds),
        provider: connectedProvider,
      );

      when(() => connectedProvider.switchChain(any())).thenThrow(jsRabbyRequestError);
      when(() => jsRabbyRequestError.data).thenReturn(jsRabbyRequestErrorData);
      when(() => jsRabbyRequestErrorData.originalError).thenReturn(JSEthereumRequestError(2113237627352.toJS));

      await sut.connect(walletDetail);

      expect(() => sut.switchNetwork("0x1"), throwsA(isNot(isA<UnrecognizedChainId>())));
    },
  );

  test(
    """When an error is thrown while `switchNetwork` is being called, the current connected wallet
    is Rabby and the error is not a Rabby request error, it should rethrow the error"",
    """,
    () async {
      final connectedProvider = EthereumProviderMock();
      const error = "Dale error";

      const rabbyRnds = "io.rabby";

      final walletDetail = WalletDetail(
        info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: rabbyRnds),
        provider: connectedProvider,
      );

      when(() => connectedProvider.switchChain(any())).thenThrow(error);

      await sut.connect(walletDetail);

      expect(() => sut.switchNetwork("0x1"), throwsA(error));
    },
  );

  test(
    "When calling `addNetwork` it should also update the signer, after the network is added",
    () async {
      final connectedProvider = EthereumProviderMock();
      final expectedNewSigner = SignerMock();
      const expectedNewSignerAddress = "0xNEW_SIGNER_ADDRESS";

      final walletDetail = WalletDetail(
        info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: "io.rabby"),
        provider: connectedProvider,
      );

      when(() => connectedProvider.addChain(any())).thenAnswer((_) async => const ChainInfo(hexChainId: "0x1"));
      await sut.connect(walletDetail);

      when(() => browserProvider.getSigner(any())).thenAnswer((_) async => expectedNewSigner);
      when(() => expectedNewSigner.address).thenAnswer((_) async => expectedNewSignerAddress);

      await sut.addNetwork(const ChainInfo(hexChainId: "0x1"));
      expect(await sut.signer!.address, await expectedNewSigner.address);
    },
  );

  test("When calling `addNetwork` it should notify that the signer has changed", () async {
    final connectedProvider = EthereumProviderMock();
    final expectedNewSigner = SignerMock();
    const expectedNewSignerAddress = "0xNEW_SIGNER_ADDRESS";
    String actualNewSignerAddress = "";

    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: "io.rabby"),
      provider: connectedProvider,
    );

    sut.signerStream.listen((signer) async => actualNewSignerAddress = await signer!.address);

    when(() => connectedProvider.addChain(any())).thenAnswer((_) async => const ChainInfo(hexChainId: "0x1"));
    await sut.connect(walletDetail);

    when(() => browserProvider.getSigner(any())).thenAnswer((_) async => expectedNewSigner);
    when(() => expectedNewSigner.address).thenAnswer((_) async => expectedNewSignerAddress);

    await sut.addNetwork(const ChainInfo(hexChainId: "0x1"));

    // Needed to wait for the signer to be updated
    await Future.delayed(const Duration(seconds: 0));

    expect(actualNewSignerAddress, await expectedNewSigner.address);
  });

  test("""When calling `nativeBalance` and not passing a rpc url, it should return the
  connected wallet native currency balance parsed to a common double from the connected
  provider""", () async {
    final connectedProvider = EthereumProviderMock();
    final jsEthereumProvider = JSEthereumProviderMock();

    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: "io.rabby"),
      provider: connectedProvider,
    );

    when(() => connectedProvider.jsEthereumProvider).thenReturn(jsEthereumProvider);
    when(() => jsEthereumProvider.getBalance(any())).thenReturn(JSPromise(JSBigInt(1000000000000000000)));

    await sut.connect(walletDetail);
    final balance = await sut.nativeBalance();

    expect(balance, 1.0);
  });

  test("""When calling `nativeBalance` and passing a rpc url, it should return the
  connected wallet native currency balance parsed to a common double using the rpc url
  to make the request""", () async {
    final connectedProvider = EthereumProviderMock();
    final jsEthereumProvider = JSEthereumProviderMock();
    const rpcUrl = "https://dale.com";

    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: "io.rabby"),
      provider: connectedProvider,
    );

    when(() => connectedProvider.jsEthereumProvider).thenReturn(jsEthereumProvider);

    await sut.connect(walletDetail);
    JSEthereumProvider.getBalanceReturn = 1000000000000000000;
    final balance = await sut.nativeBalance(rpcUrl: rpcUrl);

    expect(JSEthersJsonRpcProvider.lastRpcUrl, rpcUrl);
    expect(balance, 1.0);
  });

  test("When calling `nativeBalance` and there is not a connected wallet, it should assert", () {
    expect(() => sut.nativeBalance(), throwsAssertionError);
  });

  test("When calling 'nativeOrTokenBalance' passing a zero address, it should get the native balance", () async {
    final connectedProvider = EthereumProviderMock();
    final jsEthereumProvider = JSEthereumProviderMock();

    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: "io.rabby"),
      provider: connectedProvider,
    );

    when(() => connectedProvider.jsEthereumProvider).thenReturn(jsEthereumProvider);
    when(() => jsEthereumProvider.getBalance(any())).thenReturn(JSPromise(JSBigInt(4200000000000000000)));

    await sut.connect(walletDetail);
    final balance = await sut.nativeOrTokenBalance(EthereumConstants.zeroAddress);

    expect(balance, 4.2);
  });

  test("When calling 'nativeOrTokenBalance' passing a non-zero address, it should get the token balance", () async {
    final connectedProvider = EthereumProviderMock();
    final jsEthereumProvider = JSEthereumProviderMock();
    final erc20Impl = Erc20ImplMock();

    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: "io.rabby"),
      provider: connectedProvider,
    );

    when(() => connectedProvider.jsEthereumProvider).thenReturn(jsEthereumProvider);
    when(() => erc20.fromSigner(contractAddress: any(named: "contractAddress"), signer: any(named: "signer")))
        .thenReturn(erc20Impl);
    when(() => erc20Impl.balanceOf(account: any(named: "account"))).thenAnswer((_) async => BigInt.from(9100000));
    when(() => erc20Impl.decimals()).thenAnswer((_) async => BigInt.from(6));

    await sut.connect(walletDetail);
    final balance = await sut.nativeOrTokenBalance("0x123");

    expect(balance, 9.1);
  });

  test("When calling 'nativeOrTokenBalance' and there is not a connected wallet, it should assert", () {
    expect(() => sut.nativeOrTokenBalance(EthereumConstants.zeroAddress), throwsAssertionError);
  });

  test(
      "When calling 'nativeOrTokenBalance' and passing a rpc url, it should create the erc20 contract from the rpc url",
      () async {
    final connectedProvider = EthereumProviderMock();
    final jsEthereumProvider = JSEthereumProviderMock();
    final erc20Impl = Erc20ImplMock();
    const rpcUrl = "https://dalae.com";

    final walletDetail = WalletDetail(
      info: const WalletInfo(name: "Rabby Wallet", icon: "icon.ico", rdns: "io.rabby"),
      provider: connectedProvider,
    );

    when(() => connectedProvider.jsEthereumProvider).thenReturn(jsEthereumProvider);
    when(() => erc20.fromRpcProvider(contractAddress: any(named: "contractAddress"), rpcUrl: any(named: "rpcUrl")))
        .thenReturn(erc20Impl);
    when(() => erc20Impl.balanceOf(account: any(named: "account"))).thenAnswer((_) async => BigInt.from(9100000));
    when(() => erc20Impl.decimals()).thenAnswer((_) async => BigInt.from(6));

    await sut.connect(walletDetail);
    await sut.nativeOrTokenBalance("0x123", rpcUrl: rpcUrl);

    verify(() => erc20.fromRpcProvider(contractAddress: any(named: "contractAddress"), rpcUrl: rpcUrl)).called(1);
  });
}
