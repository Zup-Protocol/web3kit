import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/core.dart";

void main() {
  test("`parseTokenAmount` should correctly convert a dart num to an EVM decimal-like", () {
    expect(9200.parseTokenAmount(decimals: 18), BigInt.from(9200e18));
  });

  test("When passing double values to `parseTokenAmount`, it should correctly convert them to an EVM decimal-like", () {
    expect(0.5.parseTokenAmount(decimals: 18), BigInt.from(0.5e18));
  });

  test(
      "When passing increible huge values to `parseTokenAmount`, it should correctly convert them to an EVM decimal-like",
      () {
    const decimals = 18;
    expect(
      2e200.parseTokenAmount(decimals: decimals),
      BigInt.from(2) * BigInt.from(10).pow(200 + decimals),
    );
  });
}
