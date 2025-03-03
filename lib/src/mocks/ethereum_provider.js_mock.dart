// coverage:ignore-file

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthereumProvider implements JSObject {
  const JSEthereumProvider();

  static int getBalanceReturn = 0;

  void on(JSString event, JSFunction callback) {}

  JSPromise request(JSObject requestObject) => JSPromise<dynamic>(null);

  JSPromise<JSBigInt> getBalance(JSString address) => JSPromise(JSBigInt(getBalanceReturn));

  @override
  bool isA<T extends JSObject?>() {
    return true;
  }

  @override
  Map<JSAny, JSAny?> get properties => {};

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
