// coverage:ignore-file

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthereumRequestError extends JSObject {
  JSEthereumRequestError(this.code);

  final JSNumber code;
}
