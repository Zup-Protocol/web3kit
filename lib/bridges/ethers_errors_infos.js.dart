@JS()
library ethers_errors_infos_bridge;

import 'dart:js_interop';

extension type JSEthersErrorUserRejectedActionInfo._(JSObject _) implements JSObject {
  external JSEthersErrorUserRejectedActionInfo();

  external JSNumber get code;
}
