import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/inject.dart";
import "package:web3kit/src/mocks/ethers_browser_provider.js_mock.dart";
import "package:web3kit/src/mocks/ethers_network.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

import "../mocks.dart";

void main() {
  late BrowserProvider sut;

  setUp(() {
    sut = BrowserProvider();
    mockInjections(customBrowserProvider: sut);
  });

  tearDown(() => resetInjections());

  test("When calling `shared` it should return a BrowserProvider instance", () async {
    Inject.getInjections();

    expect(BrowserProvider.shared.hashCode, sut.hashCode);
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

  test("""When calling `getNetwork` it should ask the JS implementation
   of the browser provider, for network information""", () async {
    final ethereumProvider = EthereumProviderMock();
    final jsEthereumProvider = JSEthereumProviderMock();
    const expectedChainIdHex = "0x1";
    const expectedChainIdInt = 1;
    const expectedChainName = "DALE";

    when(() => ethereumProvider.jsEthereumProvider).thenReturn(jsEthereumProvider);

    JSEthersBrowserProvider.getNetworkResult = JSEthersNetwork(
      chainId: JSBigInt(expectedChainIdInt),
      name: const JSString(expectedChainName),
    );

    final chainInfo = await sut.getNetwork(ethereumProvider);

    expect(chainInfo.chainName, expectedChainName, reason: "Chain name does not match the expected one");
    expect(chainInfo.hexChainId, expectedChainIdHex, reason: "ChainID Hex does not match the expected value");
  });

  test("""When calling `getNetwork` it should use
  the correct radix (16) to convert the chain id from number to hex""", () async {
    final ethereumProvider = EthereumProviderMock();
    final jsEthereumProvider = JSEthereumProviderMock();
    const expectedChainIdHex = "0x6e4216";
    const expectedChainIdInt = 7225878;

    when(() => ethereumProvider.jsEthereumProvider).thenReturn(jsEthereumProvider);

    JSEthersBrowserProvider.getNetworkResult = JSEthersNetwork(
      chainId: JSBigInt(expectedChainIdInt),
      name: const JSString(""),
    );

    final chainInfo = await sut.getNetwork(ethereumProvider);

    expect(chainInfo.hexChainId, expectedChainIdHex);
  });

  test("When calling `getNetwork` it should prefix the chain id with `0x`", () async {
    final ethereumProvider = EthereumProviderMock();
    final jsEthereumProvider = JSEthereumProviderMock();
    const expectedChainIdInt = 12;

    when(() => ethereumProvider.jsEthereumProvider).thenReturn(jsEthereumProvider);

    JSEthersBrowserProvider.getNetworkResult = JSEthersNetwork(
      chainId: JSBigInt(expectedChainIdInt),
      name: const JSString(""),
    );

    final chainInfo = await sut.getNetwork(ethereumProvider);

    expect(chainInfo.hexChainId.startsWith("0x"), true);
  });
}
