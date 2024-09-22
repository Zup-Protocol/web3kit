class EthereumRequestException implements Exception {}

class UnrecognizedChainId implements EthereumRequestException {
  UnrecognizedChainId(this.hexChainId);

  final String hexChainId;

  @override
  String toString() {
    return "UnrecognizedChainId($hexChainId): The chain Id is not recognized by the wallet. Because it's either not supported or not added yet. You can try to add it first";
  }
}
