@JS()
library eip_6963_event;

import 'dart:js_interop';

@JS("info")
extension type JSEIP6963DetailInfo._(JSObject _) implements JSObject {
  external JSEIP6963DetailInfo();

  external JSString get name;
  external JSString get icon;
  external JSString get rdns;
}
