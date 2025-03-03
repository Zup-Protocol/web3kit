/// Constants of things that are relevant to the Ethereum blockchain
abstract class EthereumConstants {
  /// The maximum value that can be stored in a 256 bit integer
  static BigInt uint256Max = BigInt.from(2).pow(256) - BigInt.from(1);

  static String zeroAddress = "0x0000000000000000000000000000000000000000";
}
