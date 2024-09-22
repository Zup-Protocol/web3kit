enum EthereumRequestError { unrecognizedChainId }

extension EthereumRequestErrorExtension on EthereumRequestError {
  int get code => [4902][index];
}
