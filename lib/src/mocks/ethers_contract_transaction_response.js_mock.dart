import "package:web3kit/src/mocks/ethers_contract_transaction_receipt.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthersContractTransactionResponse extends JSObject {
  JSEthersContractTransactionResponse({this.customChainId, this.customHash});

  final JSBigInt? customChainId;
  final JSString? customHash;

  JSBigInt get chainId => customChainId ?? JSBigInt(1);
  JSString get hash => customHash ?? const JSString("0x1");

  JSPromise<JSEthersContractTransactionReceipt> wait() => JSPromise<JSEthersContractTransactionReceipt>(
        JSEthersContractTransactionReceipt(),
      );
}
