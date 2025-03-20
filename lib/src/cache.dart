import "package:freezed_annotation/freezed_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

@internal
enum CacheKey {
  connectedWallet;

  String get key => toString();

  static Set<String> get keys => values.map((key) => key.key).toSet();
}

@internal
class Cache {
  Cache(this._cache);
  final SharedPreferencesWithCache _cache;

  Future<void> setWalletConnectionState(String? walletRdns) async {
    await _cache.setString(CacheKey.connectedWallet.key, walletRdns ?? "");
  }

  Future<String?> getConnectedWallet() async {
    return _cache.getString(CacheKey.connectedWallet.key);
  }
}
