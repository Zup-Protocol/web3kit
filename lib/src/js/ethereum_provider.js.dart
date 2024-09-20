@JS()
library ethereum;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

extension type JSEthereumProvider._(JSObject _) implements JSObject {
  external JSEthereumProvider();

  external void on(JSString event, JSFunction callback);

  external JSPromise request(JSObject method);
}
