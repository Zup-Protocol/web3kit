import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/core/exceptions/ethereum_request_exceptions.dart";
import "package:web3kit/core/exceptions/ethers_exceptions.dart";
import "package:web3kit/src/cache.dart";
import "package:web3kit/src/enums/eip_6963_event_enum.dart";
import "package:web3kit/src/enums/ethereum_event.dart";
import "package:web3kit/src/enums/ethers_error_code.dart";
import "package:web3kit/src/inject.dart";
import "package:web3kit/src/mocks/eip_6963_detail.js_mock.dart";
import "package:web3kit/src/mocks/eip_6963_detail_info.js_mock.dart";
import "package:web3kit/src/mocks/eip_6963_event.js_mock.dart";
import "package:web3kit/src/mocks/ethereum_request_error.js_mock.dart";
import "package:web3kit/src/mocks/ethers_errors.js_mock.dart";
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

  setUp(() {
    browserProvider = BrowserProviderMock();
    cache = CacheMock();
    window = _CustomWindowMock();
    final signer = SignerMock();

    sut = Wallet(browserProvider, cache, window);

    registerFallbackValue(JSFunction(() {}));
    registerFallbackValue(const JSString(""));
    registerFallbackValue(EthereumProviderMock());
    registerFallbackValue(const ChainInfo(hexChainId: ""));

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

      final wallet = Wallet(browserProvider, cache, window0);

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

      final wallet = Wallet(browserProvider, cache, window0);
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

      final wallet = Wallet(browserProvider, cache, window0);

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

      final wallet = Wallet(browserProvider, cache, window0);
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
    when(() => browserProvider.getNetwork(any())).thenAnswer((_) async => connectedNetwork);

    final ethereumProvider = EthereumProviderMock();
    final walletDetail =
        WalletDetail(info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"), provider: ethereumProvider);

    await sut.connect(walletDetail);

    expect(await sut.connectedNetwork, connectedNetwork);
  });
}
