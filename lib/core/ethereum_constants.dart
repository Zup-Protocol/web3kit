/// Constants of things that are relevant to the Ethereum blockchain
abstract class EthereumConstants {
  /// The maximum value that can be stored in a 256 bit integer
  static BigInt uint256Max = BigInt.from(2).pow(256) - BigInt.from(1);

  /// The maximum value that can be stored in a 160 bit integer
  static BigInt uint160Max = BigInt.from(2).pow(160) - BigInt.from(1);

  /// The maximum value that can be stored in a 48 bit integer
  static BigInt uint48Max = BigInt.from(2).pow(48) - BigInt.from(1);

  /// Get the zero address as Ethereum address
  static const String zeroAddress = "0x0000000000000000000000000000000000000000";

  /// Get the empty bytes as a hex string
  static const String emptyBytes = "0x";
}
