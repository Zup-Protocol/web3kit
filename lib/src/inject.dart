import "package:freezed_annotation/freezed_annotation.dart";
import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:web3kit/core/browser_provider.dart";
import "package:web3kit/core/wallet.dart";
import "package:web3kit/src/abis/erc_20.abi.g.dart";
import "package:web3kit/src/cache.dart";
import "package:web3kit/src/launcher.dart";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart" if (dart.library.html) "package:web/web.dart" hide Cache;

class Inject {
  Inject._({
    required this.browserProvider,
    required this.wallet,
    required this.launcher,
    required this.sharedPreferencesWithCache,
  });

  static final _getIt = GetIt.instance;

  static Inject? _inject;

  static Inject get shared => _inject!;

  final BrowserProvider browserProvider;
  final Wallet wallet;
  final Launcher launcher;
  final SharedPreferencesWithCache sharedPreferencesWithCache;

  static Future<void> setup() async {
    await _getIt.reset();

    _getIt.registerSingletonAsync<SharedPreferencesWithCache>(
      () async => await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(allowList: CacheKey.keys),
      ),
    );
    _getIt.registerLazySingleton<Cache>(() => Cache(_getIt<SharedPreferencesWithCache>()));
    _getIt.registerLazySingleton<BrowserProvider>(() => BrowserProvider());
    _getIt.registerLazySingleton<Window>(() => window);
    _getIt.registerLazySingleton<Launcher>(() => Launcher());
    _getIt.registerLazySingleton<Erc20>(() => Erc20());
    _getIt.registerLazySingleton<Wallet>(() => Wallet(
          _getIt<BrowserProvider>(),
          _getIt<Cache>(),
          _getIt<Window>(),
          _getIt<Erc20>(),
        ));

    await _getIt.allReady();

    getInjections();
  }

  @visibleForTesting
  static void getInjections() {
    _inject = _inject = Inject._(
      browserProvider: _getIt<BrowserProvider>(),
      wallet: _getIt<Wallet>(),
      launcher: _getIt<Launcher>(),
      sharedPreferencesWithCache: _getIt<SharedPreferencesWithCache>(),
    );
  }
}
