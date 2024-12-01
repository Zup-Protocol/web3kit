@JS()
library ethers_contract_transaction_response;

import "package:web3kit/src/mocks/ethers_contract_transaction_receipt.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_contract_transction_receipt.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

@JS("ethers.ContractTransactionResponse")
extension type JSEthersContractTransactionResponse._(JSObject _) implements JSObject {
  external JSEthersContractTransactionResponse();

  external JSBigInt get chainId;
  external JSString get hash;
  external JSPromise<JSEthersContractTransactionReceipt> wait();
}
