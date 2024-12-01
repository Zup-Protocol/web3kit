import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/utils.js_mock.dart" if (dart.library.html) "package:web3kit/src/js/utils.js.dart";

extension BigIntExtension on BigInt {
  JSBigInt get toJS => createJSBigInt(toString().toJS);
}
