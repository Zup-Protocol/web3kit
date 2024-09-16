@JS()
library ethers_errors_bridge;

import 'dart:js_interop';

@JS("Error")
extension type JSEthersError._(JSObject _) implements JSObject {
  external JSEthersError(JSString code);

  external JSString get code;
}
