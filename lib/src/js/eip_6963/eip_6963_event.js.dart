@JS()
library eip_6963_event;

import "package:web3kit/src/js/eip_6963/eip_6963_detail.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart" if (dart.library.html) "package:web/web.dart" hide Cache;

@JS("CustomEvent")
extension type JSEIP6963Event._(Event _) implements Event {
  external JSEIP6963Event(JSString type);

  external JSEIP6963Detail get detail;
}
