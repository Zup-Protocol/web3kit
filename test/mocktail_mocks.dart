import "package:mocktail/mocktail.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:web3kit/core/browser_provider.dart";
import "package:web3kit/core/ethereum_provider.dart";
import "package:web3kit/core/signer.dart";
import "package:web3kit/core/wallet.dart";
import "package:web3kit/src/cache.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart" hide Cache;

class SharedPreferencesWithCacheMock extends Mock implements SharedPreferencesWithCache {}

class WalletMock extends Mock implements Wallet {}

class CacheMock extends Mock implements Cache {}

class BrowserProviderMock extends Mock implements BrowserProvider {}

class WindowMock extends Mock implements Window {}

class EthereumProviderMock extends Mock implements EthereumProvider {}

class JSEthereumProviderMock extends Mock implements JSEthereumProvider {}

class SignerMock extends Mock implements Signer {}
