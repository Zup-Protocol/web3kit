@JS()
library ethers_errors_bridge;

import 'dart:js_interop';

import 'ethers_errors_infos.js.dart';

extension type JSEthersError._(JSObject _) implements JSObject {
  external JSEthersError();

  external JSString get code;
  external JSEthersErrorInfo get info;
}

extension type JSEthersErrorInfo._(JSObject _) implements JSObject {
  external JSEthersErrorInfo();

  @JS("error")
  external JSEthersErrorUserRejectedActionInfo get userRejectedActionInfo;
}
