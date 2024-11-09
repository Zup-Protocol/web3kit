// coverage:ignore-file

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthersNetwork {
  final JSBigInt chainId;
  final JSString name;

  JSEthersNetwork({required this.chainId, required this.name});
}
