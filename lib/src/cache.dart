import "package:freezed_annotation/freezed_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

@internal
class Cache {
  Cache(this._cache);
  final SharedPreferencesWithCache _cache;

  final _connectedWalletKey = "CONNECTED_WALLET";

  Future<void> setWalletConnectionState(String? walletRdns) async {
    await _cache.setString(_connectedWalletKey, walletRdns ?? "");
  }

  Future<String?> getConnectedWallet() async {
    return _cache.getString(_connectedWalletKey);
  }
}
