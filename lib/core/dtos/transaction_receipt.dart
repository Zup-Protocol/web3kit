/// Receipt received when a transaction is confirmed by at least one block
class TransactionReceipt {
  TransactionReceipt({required this.hash});

  /// The hash of the transaction
  final String hash;
}
