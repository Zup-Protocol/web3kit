import "package:equatable/equatable.dart";
import "package:web3kit/core/dtos/wallet_info.dart";
import "package:web3kit/core/ethereum_provider.dart";

/// DTO with details about a specific wallet provider following the [EIP-6963](https://eips.ethereum.org/EIPS/eip-6963)
class WalletDetail extends Equatable {
  final WalletInfo info;
  final EthereumProvider provider;

  const WalletDetail({required this.info, required this.provider});

  @override
  List<Object?> get props => [info, provider];
}
