@JS()
library eip_6963_detail;

import "package:web3kit/src/js/eip_6963/eip_6063_detail_info.js.dart";
import "package:web3kit/src/js/ethereum_provider.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("detail")
extension type JSEIP6963Detail._(JSObject _) implements JSObject {
  external JSEIP6963Detail();

  external JSEIP6963DetailInfo get info;
  external JSEthereumProvider get provider;
}
