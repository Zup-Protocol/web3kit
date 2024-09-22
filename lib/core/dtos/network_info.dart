import "package:equatable/equatable.dart";
import "package:web3kit/core/dtos/native_currency.dart";

/// DTO with information about a specific network. Following the standard from EIP-3085
///
/// For more information about EIP-3085, please refer to [EIP-3085](https://eips.ethereum.org/EIPS/eip-3085)
class NetworkInfo extends Equatable {
  /// the hex value of the chain id. E.g `0x1` for Ethereum mainnet, which in decimal is 1
  final String hexChainId;

  /// The block explorer urls for the network, e.g https://etherscan.io for Ethereum mainnet
  final List<String>? blockExplorerUrls;

  /// The name of the network. E.g. "Ethereum Mainnet"
  final String? chainName;

  /// The Icon of the network, to be displayed in the wallet
  final List<String>? iconsURLs;

  /// Information about the native currency of the network
  final NativeCurrency? nativeCurrency;

  /// The list of rpc urls that can be used for the network
  final List<String>? rpcUrls;

  const NetworkInfo({
    required this.hexChainId,
    this.blockExplorerUrls,
    this.chainName,
    this.iconsURLs,
    this.nativeCurrency,
    this.rpcUrls,
  });

  @override
  List<Object?> get props => [hexChainId, blockExplorerUrls, chainName, iconsURLs, nativeCurrency, rpcUrls];
}
