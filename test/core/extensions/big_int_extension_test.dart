import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/extensions/big_int_extension.dart";

void main() {
  group("when calling `parseTokenAmount` it should parse from a EVM like decimals, to a dart-like double", () {
    test("1e18 -> 1.0", () {
      expect(BigInt.from(1e18).parseTokenAmount(decimals: 18), 1.0);
    });

    test("1e17 -> 0.1", () {
      expect(BigInt.from(1e17).parseTokenAmount(decimals: 18), 0.1);
    });
  });
}
