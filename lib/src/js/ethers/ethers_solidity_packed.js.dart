@JS()
library ethers_solidity_packed;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("ethers.solidityPacked")
external JSString ethersSolidityPacked(JSArray<JSString> types, JSArray<JSAny> values);
