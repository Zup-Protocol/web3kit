import "package:web3kit/web3kit.dart";

/// Enum representing native currencies of the networks
enum NativeCurrencies { eth, bnb, pol, avax, hype, xpl }

extension NativeCurrenciesExtension on NativeCurrencies {
  /// Get info about the currency, using the [NativeCurrency] object
  NativeCurrency get currencyInfo => switch (this) {
    NativeCurrencies.eth => const NativeCurrency(
      name: "Ethereum",
      symbol: "ETH",
      decimals: 18,
      logoUrl: "https://assets-cdn.trustwallet.com/blockchains/ethereum/info/logo.png",
    ),
    NativeCurrencies.bnb => const NativeCurrency(
      name: "BNB",
      symbol: "BNB",
      decimals: 18,
      logoUrl: "https://assets-cdn.trustwallet.com/blockchains/binance/info/logo.png",
    ),

    NativeCurrencies.pol => const NativeCurrency(
      name: "Polygon Ecosystem Token",
      symbol: "POL",
      decimals: 18,
      logoUrl: "https://assets-cdn.trustwallet.com/blockchains/polygon/info/logo.png",
    ),

    NativeCurrencies.avax => const NativeCurrency(
      name: "Avalanche",
      symbol: "AVAX",
      decimals: 18,
      logoUrl: "https://assets-cdn.trustwallet.com/blockchains/avalanchex/info/logo.png",
    ),

    NativeCurrencies.hype => const NativeCurrency(
      name: "Hyperliquid",
      symbol: "HYPE",
      decimals: 18,
      logoUrl: "https://s2.coinmarketcap.com/static/img/coins/128x128/32196.png",
    ),

    NativeCurrencies.xpl => const NativeCurrency(
      name: "Plasma",
      symbol: "XPL",
      decimals: 18,
      logoUrl: "https://s2.coinmarketcap.com/static/img/coins/128x128/36645.png",
    ),
  };
}
