@JS()
library ethers_contract_transaction_response;

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("ethers.ContractTransactionReceipt")
extension type JSEthersContractTransactionReceipt._(JSObject _) implements JSObject {
  external JSEthersContractTransactionReceipt();

  external JSString get hash;
}
