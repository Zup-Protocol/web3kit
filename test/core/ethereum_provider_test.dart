import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/enums/ethereum_event.dart";
import "package:web3kit/src/enums/ethereum_request.dart";
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

  test("When calling `revokePermissions` it should set the right properties in the request body", () async {
    final expectedRequestObject = JSObject()
      ..setProperty("method".toJS, EthereumRequest.revokePermissions.method.toJS)
      ..setProperty(
          "params".toJS,
          [
            {
              "eth_accounts": {},
            }
          ].jsify());

    sut.revokePermissions();

    expect(
      jsEthereumProvider.lastRequestObject,
      expectedRequestObject,
      reason: "Both object values should be the same",
    );
  });
}
