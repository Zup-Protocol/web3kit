extension NumExtension on num {
  /// Convert a token amount from its common decimals representation to its EVM representation (e.g 1 -> 1000000000000000000)
  BigInt parseTokenAmount({required int decimals}) => BigInt.from(this) * BigInt.from(10).pow(decimals);
}
