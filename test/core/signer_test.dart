import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/enums/ethers_error_code.dart";
import "package:web3kit/src/mocks/ethers_browser_provider.js_mock.dart";
import "package:web3kit/src/mocks/ethers_errors.js_mock.dart";
import "package:web3kit/src/mocks/ethers_signer.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

import "../mocks.dart";

void main() {
  late Signer sut;
  late JSEthersSigner jsEthersSigner;
  late JSEthersBrowserProvider jsEthersBrowserProvider;

  setUp(() {
    jsEthersSigner = JSEthersSignerMock();
    jsEthersBrowserProvider = JSEthersBrowserProviderMock();

    sut = Signer(jsEthersSigner, jsEthersBrowserProvider);
    registerFallbackValue(const JSString(""));
  });

  test("When calling `address` it should call the JS implementation of the Signer", () async {
    const address = "0x123";
    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString(address)));

    expect(await sut.address, address);

    verify(() => jsEthersSigner.getAddress()).called(1);
  });

  test("When calling `ensName` it should use JS implementation of the browser provider to get the ENS name", () async {
    const ensName = "DALE";

    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));
    when(() => jsEthersBrowserProvider.lookupAddress(any())).thenReturn(JSPromise<JSString?>(const JSString(ensName)));

    expect(await sut.ensName, ensName);

    verify(() => jsEthersBrowserProvider.lookupAddress(any())).called(1);
  });

  test("""When calling `ensName` it should use JS implementation of the browser provider to get the ENS name.
  If it return null, it should not throw anything
  """, () async {
    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));
    when(() => jsEthersBrowserProvider.lookupAddress(any())).thenReturn(JSPromise<JSString?>(null));

    expect(await sut.ensName, null);

    verify(() => jsEthersBrowserProvider.lookupAddress(any())).called(1);
  });

  test(
      "When calling `ensName` and the JS Implementation throw a exception of unsupported operation, it should return null",
      () async {
    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));
    when(() => jsEthersBrowserProvider.lookupAddress(any())).thenThrow(
      JSEthersError(EthersError.unsupportedOperation.code.toJS),
    );

    expect(await sut.ensName, null);

    verify(() => jsEthersBrowserProvider.lookupAddress(any())).called(1);
  });

  test(
      "When calling `ensName` and the JS Implementation throw a exception other than unsupported operation, it should rethrow",
      () async {
    const error = "ERROR";

    when(() => jsEthersSigner.getAddress()).thenReturn(JSPromise<JSString>(const JSString("0x123")));
    when(() => jsEthersBrowserProvider.lookupAddress(any())).thenThrow(error);

    expect(() async => await sut.ensName, throwsA(error));
  });
}
