import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/dtos/transaction_response.dart";
import "package:web3kit/src/extensions/bigint_extension.dart";
import "package:web3kit/src/mocks/ethers_contract_transaction_receipt.js_mock.dart";
import "package:web3kit/src/mocks/ethers_contract_transaction_response.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

import "../../mocks.dart";

void main() {
  late TransactionResponse sut;
  late JSEthersContractTransactionResponse jsEthersContractTransactionResponse;

  setUp(() {
    jsEthersContractTransactionResponse = JSEthersContractTransactionResponseMock();

    sut = TransactionResponse(
      chainId: BigInt.from(1),
      hash: "",
      transactionResponse: jsEthersContractTransactionResponse,
    );

    when(() => jsEthersContractTransactionResponse.wait()).thenAnswer(
      (_) => JSPromise<JSEthersContractTransactionReceipt>(
        JSEthersContractTransactionReceipt(),
      ),
    );
  });

  test(
    """When calling `waitTransaction` it should call wait in the JS implementation, and return the receipt
    with the txid got from the JS implementation
    """,
    () async {
      const txid = "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef";

      when(() => jsEthersContractTransactionResponse.wait()).thenAnswer(
        (_) => JSPromise<JSEthersContractTransactionReceipt>(
          JSEthersContractTransactionReceipt(txid),
        ),
      );

      final receipt = await sut.waitConfirmation();

      verify(() => jsEthersContractTransactionResponse.wait()).called(1);

      expect(receipt.hash, txid);
    },
  );

  test(
    """When using the factory `fromJS` it should return an instance of the class with the params
    from the JS implementation
    """,
    () {
      final chainId = BigInt.from(21);
      const hash = "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef";

      final jsEthersContractTransactionResponse = JSEthersContractTransactionResponse(
        customChainId: chainId.toJS,
        customHash: hash.toJS,
      );

      final TransactionResponse sut = TransactionResponse.fromJS(jsEthersContractTransactionResponse);

      expect(sut.chainId, chainId);
      expect(sut.hash, hash);
    },
  );
}
