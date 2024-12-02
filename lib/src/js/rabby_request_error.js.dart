@JS()
library rabby_request_error;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/rabby_request_error_data.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/rabby_request_error_data.js.dart";

@JS("Error")
extension type JSRabbyRequestError._(JSObject _) implements JSObject {
  external JSRabbyRequestError();

  external JSRabbyRequestErrorData get data;
}
