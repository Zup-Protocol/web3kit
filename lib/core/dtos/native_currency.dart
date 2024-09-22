import "package:equatable/equatable.dart";

/// DTO with information about the native currency of the network, following the standard from EIP-3085
///
/// For more information about EIP-3085, please refer to [EIP-3085](https://eips.ethereum.org/EIPS/eip-3085)
class NativeCurrency extends Equatable {
  /// The full name of the native currency, e.g. "Ethereum"
  final String name;

  /// The symbol of the native currency, e.g. "ETH"
  final String symbol;

  /// The number of decimals used by the native currency, e.g. 18
  final int decimals;

  const NativeCurrency({required this.name, required this.symbol, required this.decimals});

  @override
  List<Object?> get props => [name, symbol, decimals];
}
