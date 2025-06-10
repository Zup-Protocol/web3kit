@JS()
library ethers_abi_coder;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("ethers.AbiCoder")
extension type JSEthersAbiCoder._(JSObject _) implements JSObject {
  external JSEthersAbiCoder();

  external JSString encode(JSArray<JSString> types, JSArray<JSAny> values);
  external JSArray<JSAny> decode(JSArray<JSString> types, JSString data);
}
