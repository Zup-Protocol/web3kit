import 'package:get_it/get_it.dart';
import 'package:web3kit/core/ethers/ethers.dart';
import 'package:web3kit/core/wallet.dart';

final inject = GetIt.instance;

Future<void> setupInjections() async {
  await inject.reset();

  inject.registerLazySingleton<Ethers>(() => Ethers());
  inject.registerLazySingleton<Wallet>(() => Wallet(ethers: inject<Ethers>()));

  await inject.allReady();
}
