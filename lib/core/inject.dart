import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3kit/core/browser_provider.dart';
import 'package:web3kit/core/cache.dart';
import 'package:web3kit/core/wallet.dart';

final inject = GetIt.instance;

Future<void> setupInjections() async {
  await inject.reset();
  inject.registerSingletonAsync<SharedPreferencesWithCache>(
    () async => await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    ),
  );
  inject.registerLazySingleton<Cache>(() => Cache(inject<SharedPreferencesWithCache>()));
  inject.registerLazySingleton<BrowserProvider>(() => BrowserProvider());
  inject.registerLazySingleton<Wallet>(() => Wallet(inject<BrowserProvider>(), inject<Cache>()));

  await inject.allReady();
}
