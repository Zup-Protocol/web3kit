import "dart:math";

extension BigIntExtension on BigInt {
  /// Convert a token amount from its EVM representation to a double with common decimals
  ///
  /// Example: 1e18 -> 1.0
  double parseTokenAmount({required int decimals}) => this / BigInt.from(pow(10, decimals));
}
