@JS()
library eip_6963_detail;

import 'dart:js_interop';

import 'package:web3kit/core/js/eip_6963/eip_6063_detail_info.js.dart';
import 'package:web3kit/core/js/ethereum_provider.js.dart';

@JS("detail")
extension type JSEIP6963Detail._(JSObject _) implements JSObject {
  external JSEIP6963Detail();

  external JSEIP6963DetailInfo get info;
  external JSEthereumProvider get provider;
}
