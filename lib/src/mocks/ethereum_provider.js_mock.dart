import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthereumProvider implements JSObject {
  const JSEthereumProvider();
  void on(JSString event, JSFunction callback) {}

  JSPromise request(JSObject requestObject) => JSPromise<dynamic>(null);

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
