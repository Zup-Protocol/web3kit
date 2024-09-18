import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

@internal
class JSEthereumProvider {
  const JSEthereumProvider();

  void on(JSString event, JSFunction callback) {}

  JSPromise request(JSObject requestObject) => JSPromise();
}
