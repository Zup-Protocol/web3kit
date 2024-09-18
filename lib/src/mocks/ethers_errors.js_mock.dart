import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthersError extends JSObject {
  JSEthersError(this.code);

  final JSString code;
}
