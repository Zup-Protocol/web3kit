import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/dtos/native_currency.dart";
import "package:web3kit/core/enums/native_currencies.dart";

void main() {
  test("When getting the `currencyInfo` for the eth, it should return the correct info", () {
    expect(
      NativeCurrencies.eth.currencyInfo,
      const NativeCurrency(
        name: "Ethereum",
        symbol: "ETH",
        decimals: 18,
        logoUrl: "https://assets-cdn.trustwallet.com/blockchains/ethereum/info/logo.png",
      ),
    );
  });

  test("When getting the `currencyInfo` for the bnb, it should return the correct info", () {
    expect(
      NativeCurrencies.bnb.currencyInfo,
      const NativeCurrency(
        name: "BNB",
        symbol: "BNB",
        decimals: 18,
        logoUrl: "https://assets-cdn.trustwallet.com/blockchains/binance/info/logo.png",
      ),
    );
  });

  test("When getting the `currencyInfo` for the hyper, it should return the correct info", () {
    expect(
      NativeCurrencies.hype.currencyInfo,
      const NativeCurrency(
        name: "Hyperliquid",
        symbol: "HYPE",
        decimals: 18,
        logoUrl: "https://s2.coinmarketcap.com/static/img/coins/128x128/32196.png",
      ),
    );
  });

  test("When getting the `currencyInfo` for the pol, it should return the correct info", () {
    expect(
      NativeCurrencies.pol.currencyInfo,
      const NativeCurrency(
        name: "Polygon Ecosystem Token",
        symbol: "POL",
        decimals: 18,
        logoUrl: "https://assets-cdn.trustwallet.com/blockchains/polygon/info/logo.png",
      ),
    );
  });

  test("When getting the `currencyInfo` for the avax, it should return the correct info", () {
    expect(
      NativeCurrencies.avax.currencyInfo,
      const NativeCurrency(
        name: "Avalanche",
        symbol: "AVAX",
        decimals: 18,
        logoUrl: "https://assets-cdn.trustwallet.com/blockchains/avalanchex/info/logo.png",
      ),
    );
  });

  test("When getting the `currencyInfo` for the xpl, it should return the correct info", () {
    expect(
      NativeCurrencies.xpl.currencyInfo,
      const NativeCurrency(
        name: "Plasma",
        symbol: "XPL",
        decimals: 18,
        logoUrl: "https://s2.coinmarketcap.com/static/img/coins/128x128/36645.png",
      ),
    );
  });
}
