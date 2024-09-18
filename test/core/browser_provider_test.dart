import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/mocks/ethers_browser_provider.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

import "../mocks.dart";

void main() {
  late BrowserProvider sut;

  setUp(() {
    sut = BrowserProvider();
  });

  test("When calling `shared` it should return a BrowserProvider instance set in the Web3Client", () async {
    final browserProvider = BrowserProviderMock();

    await Web3Client.rawInitialize(
        automaticallyConnectWallet: false, browserProvider: browserProvider, wallet: WalletMock());

    expect(Web3Client.shared.browserProvider.hashCode, browserProvider.hashCode);
  });

  test("""when calling `getSigner` it should create an instance of the
      JS Implementation of the Browser Provider with the passed Ethereum Provider""", () async {
    final ethereumProvider = EthereumProviderMock();

    when(() => ethereumProvider.jsEthereumProvider).thenReturn(JSEthereumProviderMock());

    await sut.getSigner(ethereumProvider);

    expect(
      JSEthersBrowserProvider.lastCreatedInstance!.jsEthereumProvider.hashCode,
      ethereumProvider.jsEthereumProvider.hashCode,
    );
  });

  test("""when calling `getSigner` it should get the signer from the JS Implementation of
      the browser provider""", () async {
    final ethereumProvider = EthereumProviderMock();
    final expectedSigner = JSEthersSignerMock();
    JSEthersBrowserProvider.jsEthersSigner = expectedSigner;

    when(() => expectedSigner.getAddress()).thenReturn(JSPromise(const JSString("0xRANDOM_ADDRESS")));

    when(() => ethereumProvider.jsEthereumProvider).thenReturn(JSEthereumProviderMock());

    final actualSigner = await sut.getSigner(ethereumProvider);

    expect(await actualSigner.address, (await (expectedSigner.getAddress().toDart)).toDart);
  });
}
