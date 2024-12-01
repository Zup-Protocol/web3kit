import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/core.dart";

void main() {
  test("`parseTokenAmount` should correctly convert a dart num to an EVM decimal-like", () {
    expect(9200.parseTokenAmount(decimals: 18), BigInt.from(9200e18));
  });
}
