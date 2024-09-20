import "package:equatable/equatable.dart";

/// DTO with Information about a specific wallet following the [EIP-6963](https://eips.ethereum.org/EIPS/eip-6963)
class WalletInfo extends Equatable {
  final String name;
  final String icon;
  final String rdns;

  const WalletInfo({required this.name, required this.icon, required this.rdns});

  @override
  List<Object?> get props => [name, icon, rdns];
}
