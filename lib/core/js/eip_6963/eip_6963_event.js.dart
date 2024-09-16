@JS()
library eip_6963_event;

import 'dart:js_interop';

import 'package:web/web.dart';
import 'package:web3kit/core/js/eip_6963/eip_6963_detail.js.dart';

@JS("CustomEvent")
extension type JSEIP6963Event._(Event _) implements Event {
  external JSEIP6963Event(JSString type);

  external JSEIP6963Detail get detail;
}
