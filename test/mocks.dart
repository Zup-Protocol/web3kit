import "dart:typed_data";

import "package:get_it/get_it.dart";
import "package:mocktail/mocktail.dart";
import "package:mocktail_image_network/mocktail_image_network.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:web3kit/core/browser_provider.dart";
import "package:web3kit/core/dtos/wallet_detail.dart";
import "package:web3kit/core/ethereum_provider.dart";
import "package:web3kit/core/signer.dart";
import "package:web3kit/core/wallet.dart";
import "package:web3kit/src/cache.dart";
import "package:web3kit/src/inject.dart";
import "package:web3kit/src/launcher.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart";
import "package:web3kit/src/mocks/ethers_browser_provider.js_mock.dart";
import "package:web3kit/src/mocks/ethers_signer.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart" hide Cache;

class SharedPreferencesWithCacheMock extends Mock implements SharedPreferencesWithCache {}

class WalletMock extends Mock implements Wallet {}

class CacheMock extends Mock implements Cache {}

class BrowserProviderMock extends Mock implements BrowserProvider {}

class WindowMock extends Mock implements Window {}

class EthereumProviderMock extends Mock implements EthereumProvider {}

class JSEthereumProviderMock extends Mock implements JSEthereumProvider {}

class SignerMock extends Mock implements Signer {}

class JSEthersSignerMock extends Mock implements JSEthersSigner {}

class JSEthersBrowserProviderMock extends Mock implements JSEthersBrowserProvider {}

class LauncherMock extends Mock implements Launcher {}

class WalletDetailMock extends Mock implements WalletDetail {}

// ignore: must_be_immutable
class CustomJSEthereumProviderMock extends JSEthereumProvider {
  Map<String, JSFunction> callbacks = {};
  JSObject? lastRequestObject;

  Future<void> callRegisteredEvent(String event, dynamic callbackParam) async {
    await callbacks[event]!.dartFunction.call(callbackParam);
  }

  @override
  void on(JSString event, JSFunction callback) {
    callbacks[event.toDart] = callback;
  }

  @override
  JSPromise request(JSObject requestObject) {
    lastRequestObject = requestObject;

    return JSPromise<dynamic>(null);
  }
}

T mockHttpImage<T>(T Function() on, {Uint8List? overrideImage}) {
  return mockNetworkImages(on, imageBytes: overrideImage);
}

void mockInjections({BrowserProvider? customBrowserProvider, Wallet? customWallet, Launcher? customLauncher}) {
  GetIt.I.registerFactory<BrowserProvider>(() => customBrowserProvider ?? BrowserProviderMock());
  GetIt.I.registerFactory<Wallet>(() => customWallet ?? WalletMock());
  GetIt.I.registerFactory<Launcher>(() => customLauncher ?? LauncherMock());

  Inject.getInjections();
}

void resetInjections() => GetIt.I.reset();
