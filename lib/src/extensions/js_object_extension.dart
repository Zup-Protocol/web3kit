import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/package_mocks/js_interop_unsafe_mock.dart"
    if (dart.library.html) "dart:js_interop_unsafe";

extension JSObjectExtension on JSObject {
  JSObject getEthereumRequestObject(String method, List<Map<String, JSAny>>? params) {
    setProperty("method".toJS, method.toJS);

    if (params != null) setProperty("params".toJS, params.jsify());

    return this;
  }
}
