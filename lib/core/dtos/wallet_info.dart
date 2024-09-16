/// DTO with Information about a specific wallet following the [EIP-6963](https://eips.ethereum.org/EIPS/eip-6963)
class WalletInfo {
  final String name;
  final String icon;
  final String rdns;

  WalletInfo({required this.name, required this.icon, required this.rdns});
}
