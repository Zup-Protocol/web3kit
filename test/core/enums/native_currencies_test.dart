import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/dtos/native_currency.dart";
import "package:web3kit/core/enums/native_currencies.dart";

void main() {
  test("When getting the `currencyInfo` for the eth, it should return the correct info", () {
    expect(
      NativeCurrencies.eth.currencyInfo,
      const NativeCurrency(name: "Ethereum", symbol: "ETH", decimals: 18),
    );
  });

  test("When getting the `currencyInfo` for the bnb, it should return the correct info", () {
    expect(
      NativeCurrencies.bnb.currencyInfo,
      const NativeCurrency(name: "BNB", symbol: "BNB", decimals: 18),
    );
  });

  test("When getting the `currencyInfo` for the pol, it should return the correct info", () {
    expect(
      NativeCurrencies.pol.currencyInfo,
      const NativeCurrency(name: "Polygon Ecosystem Token", symbol: "POL", decimals: 18),
    );
  });

  test("When getting the `currencyInfo` for the avax, it should return the correct info", () {
    expect(
      NativeCurrencies.avax.currencyInfo,
      const NativeCurrency(name: "Avalanche", symbol: "AVAX", decimals: 18),
    );
  });
}
