import "package:web3kit/web3kit.dart";

/// Enum representing native currencies of the networks
enum NativeCurrencies { eth, bnb, pol, avax }

extension NativeCurrenciesExtension on NativeCurrencies {
  /// Get info about the currency, using the [NativeCurrency] object
  NativeCurrency get currencyInfo => const [
        NativeCurrency(name: "Ethereum", symbol: "ETH", decimals: 18),
        NativeCurrency(name: "BNB", symbol: "BNB", decimals: 18),
        NativeCurrency(name: "Polygon Ecosystem Token", symbol: "POL", decimals: 18),
        NativeCurrency(name: "Avalanche", symbol: "AVAX", decimals: 18),
      ][index];
}
