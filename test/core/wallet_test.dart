import "package:mocktail/mocktail.dart";
import "package:test/test.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/cache.dart";
import "package:web3kit/src/enums/eip_6963_event_enum.dart";
import "package:web3kit/src/enums/ethereum_event.dart";
import "package:web3kit/src/mocks/eip_6963_detail.js_mock.dart";
import "package:web3kit/src/mocks/eip_6963_detail_info.js_mock.dart";
import "package:web3kit/src/mocks/eip_6963_event.js_mock.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart" hide Cache;

import "../mocktail_mocks.dart";

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

class _CustomJSEthereumProviderMock extends JSEthereumProvider {
  Map<String, JSFunction> callbacks = {};

  void callRegisteredEvent(String event, dynamic callbackParam) {
    callbacks[event]!.dartFunction.call(callbackParam);
  }

  @override
  void on(JSString event, JSFunction callback) {
    callbacks[event.toDart] = callback;
  }
}

void main() {
  late BrowserProvider browserProvider;
  late Cache cache;
  late Window window;
  late Wallet sut;

  setUp(() {
    final sharedPreferencesWithCache = SharedPreferencesWithCacheMock();

    browserProvider = BrowserProviderMock();
    cache = Cache(sharedPreferencesWithCache);
    window = _CustomWindowMock();

    sut = Wallet(browserProvider, cache, window);

    registerFallbackValue(JSFunction(() {}));
    registerFallbackValue(const JSString(""));
    registerFallbackValue(EthereumProviderMock());
  });

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
    test("It should listen for all installed wallets", () async {
      const walletsAmount = 5;
      final List<_CustomJSEthereumProviderMock> providers =
          List.generate(walletsAmount, (_) => _CustomJSEthereumProviderMock());
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

      expectLater(wallet.signer, emitsInOrder(List.generate(walletsAmount, (_) => null)));

      for (var i = 0; i < walletsAmount; i++) {
        providers[i].callRegisteredEvent(EthereumEvent.accountsChanged.name, JSArray<JSString>([]));
      }

      expect(wallet.connectedProvider, null);
    });
    test("""If the accountsChanged array callback is empty,
    it should emit a null event and set the connected
    provider to null""", () async {
      final provider = _CustomJSEthereumProviderMock();
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

      expectLater(wallet.signer, emits(null));

      provider.callRegisteredEvent(EthereumEvent.accountsChanged.name, JSArray<JSString>([]));

      expect(wallet.connectedProvider, null);
    });

    test("""If the accountsChanged array callback is empty,
    and has a current connected signer, it should emit a
    null event and set the connected provider to null""", () async {
      when(() => browserProvider.getSigner(any())).thenAnswer((_) async => SignerMock());
      const currentConnectedSigner = "0x36591DeBffCf727D5EEA2Cd6A745ee905Fae91C8";

      final provider = _CustomJSEthereumProviderMock();
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
      provider.callRegisteredEvent(EthereumEvent.accountsChanged.name, <JSString>[currentConnectedSigner.toJS].jsify());

      expectLater(wallet.signer, emits(null));

      provider.callRegisteredEvent(EthereumEvent.accountsChanged.name, JSArray<JSString>([]));

      expect(wallet.connectedProvider, null);
    });

    test("""If the accountsChanged array callback is not empty,
    and does not have a current connected signer, it should emit an
    event with the new connected signer and set the connected provider""", () async {
      final signer = SignerMock();
      final provider = _CustomJSEthereumProviderMock();
      final window0 = Window();
      const signerAddress = "0x36591DeBffCf727D5EEA2Cd6A745ee905Fae91C8";

      when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer);

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

      expectLater(wallet.signer, emits(signer));

      provider.callRegisteredEvent(EthereumEvent.accountsChanged.name, <JSString>[signerAddress.toJS].jsify());

      expect(wallet.connectedProvider?.jsEthereumProvider, provider);
    });

    test("""If the accountsChanged array callback is not empty,
    and we have a current connected signer, it should emit an
    event with the new connected signer and set the new connected provider""", () async {
      final signer1 = SignerMock();
      final signer2 = SignerMock();
      final provider1 = _CustomJSEthereumProviderMock();
      final provider2 = _CustomJSEthereumProviderMock();
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
      expectLater(wallet.signer, emitsInOrder([signer1, signer2]));

      when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer1);
      provider1.callRegisteredEvent(EthereumEvent.accountsChanged.name, <JSString>[signerAddress1.toJS].jsify());

      when(() => browserProvider.getSigner(any())).thenAnswer((_) async => signer2);
      provider2.callRegisteredEvent(EthereumEvent.accountsChanged.name, <JSString>[signerAddress2.toJS].jsify());

      expect(wallet.connectedProvider?.jsEthereumProvider, provider2);
    });
  });

  test("When calling `connectCachedWallet` it should return null if there are no previous cached connections", () {});
}
