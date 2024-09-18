import "package:freezed_annotation/freezed_annotation.dart";
import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:web3kit/core/browser_provider.dart";
import "package:web3kit/core/wallet.dart";
import "package:web3kit/src/cache.dart";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart" if (dart.library.html) "package:web/web.dart" hide Cache;

@internal
final inject = GetIt.instance;

@internal
Future<void> setupInjections() async {
  await inject.reset();

  inject.registerSingletonAsync<SharedPreferencesWithCache>(
    () async => await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions()),
  );
  inject.registerLazySingleton<Cache>(() => Cache(inject<SharedPreferencesWithCache>()));
  inject.registerLazySingleton<BrowserProvider>(() => BrowserProvider());
  inject.registerLazySingleton<Window>(() => window);
  inject.registerLazySingleton<Wallet>(() => Wallet(
        inject<BrowserProvider>(),
        inject<Cache>(),
        inject<Window>(),
      ));

  await inject.allReady();
}
