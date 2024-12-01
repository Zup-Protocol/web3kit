@JS()
library web3kit_JSBigInt;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("BigInt")
external JSBigInt createJSBigInt(JSString value);
