@JS()
library eip_6963_event;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("info")
extension type JSEIP6963DetailInfo._(JSObject _) implements JSObject {
  external JSEIP6963DetailInfo();

  external JSString get name;
  external JSString get icon;
  external JSString get rdns;
}
