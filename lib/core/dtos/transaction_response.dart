import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/core/dtos/transaction_receipt.dart";
import "package:web3kit/src/mocks/ethers_contract_transaction_response.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_contract_transaction_response.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

/// Response received when sending a transaction to the network.
///
/// **Warning**: This is not a transaction receipt, so it's not a confirmation of the transaction (success or failure)
/// If you want to wait for a transaction to be confirmed, please use the method [waitConfirmation] on this class
class TransactionResponse {
  TransactionResponse({
    required this.hash,
    required this.chainId,
    required this.transactionResponse,
  });

  /// The has of the sent transaction
  final String hash;

  /// The chain that the transaction was sent to
  final BigInt chainId;

  @protected
  final JSEthersContractTransactionResponse transactionResponse;

  factory TransactionResponse.fromJS(JSEthersContractTransactionResponse tx) {
    return TransactionResponse(
      hash: tx.hash.toDart,
      chainId: BigInt.parse(tx.chainId.toString()),
      transactionResponse: tx,
    );
  }

  /// Wait for the transaction to be confirmed by at least one block
  ///
  /// After the transaction is confirmed, a [TransactionReceipt] will be returned in the [Future]
  Future<TransactionReceipt> waitConfirmation() async {
    final jsReceipt = (await (transactionResponse.wait().toDart));
    return TransactionReceipt(hash: jsReceipt.hash.toDart);
  }
}
