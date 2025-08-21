import "package:web3kit/web3kit.dart";

/// Enum representing native currencies of the networks
enum NativeCurrencies { eth, bnb, pol, avax, hype }

extension NativeCurrenciesExtension on NativeCurrencies {
  /// Get info about the currency, using the [NativeCurrency] object
  NativeCurrency get currencyInfo => const [
    NativeCurrency(
      name: "Ethereum",
      symbol: "ETH",
      decimals: 18,
      logoUrl: "https://assets-cdn.trustwallet.com/blockchains/ethereum/info/logo.png",
    ),
    NativeCurrency(
      name: "BNB",
      symbol: "BNB",
      decimals: 18,
      logoUrl: "https://assets-cdn.trustwallet.com/blockchains/binance/info/logo.png",
    ),
    NativeCurrency(
      name: "Polygon Ecosystem Token",
      symbol: "POL",
      decimals: 18,
      logoUrl: "https://assets-cdn.trustwallet.com/blockchains/polygon/info/logo.png",
    ),
    NativeCurrency(
      name: "Avalanche",
      symbol: "AVAX",
      decimals: 18,
      logoUrl: "https://assets-cdn.trustwallet.com/blockchains/avalanchex/info/logo.png",
    ),
    NativeCurrency(
      name: "Hyperliquid",
      symbol: "HYPE",
      decimals: 18,
      logoUrl: "https://s2.coinmarketcap.com/static/img/coins/128x128/32196.png",
    ),
  ][index];
}
