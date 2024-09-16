@JS()
library ethereum;

import 'dart:js_interop';

extension type JSEthereumProvider._(JSObject _) implements JSObject {
  external JSEthereumProvider();

  external void on(JSString event, JSFunction callback);

  external JSPromise request(JSObject method);
}
