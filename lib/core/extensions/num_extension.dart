import "package:decimal/decimal.dart";

extension NumExtension on num {
  /// Convert a token amount from its common decimals representation to its EVM representation (e.g 1 -> 1000000000000000000)
  BigInt parseTokenAmount({required int decimals}) {
    final base = Decimal.parse(toString());
    final exponent = Decimal.fromInt(10).pow(decimals).toDecimal();

    return (base * exponent).toBigInt();
  }
}
