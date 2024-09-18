import "package:mocktail/mocktail.dart";
import "package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart";
import "package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart";
import "package:test/test.dart";
import "package:web3kit/core/web3_client.dart";

import "../mocks.dart";

void main() {
  late BrowserProviderMock browserProvider;
  late WalletMock wallet;

  setUp(() {
    browserProvider = BrowserProviderMock();
    wallet = WalletMock();

    when(() => wallet.connectCachedWallet()).thenAnswer((_) => Future.value(null));

    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  tearDown(() => Web3Client.dispose());

  test("When calling `shared` without initializing the client it should throw an exception", () {
    expect(
      () => Web3Client.shared.wallet,
      throwsA(
          "Web3client has not been initialized. Please initialize it with `Web3client.initialize()`, before using the client"),
    );
  });

  test("When calling initialize, and it has already been initialized, should throw an exception", () async {
    await Web3Client.initialize(automaticallyConnectWallet: false);
    expect(() async => await Web3Client.initialize(automaticallyConnectWallet: false),
        throwsA("Web3client has already been initialized. Please use `Web3client.shared` instead"));
  });

  test("When calling initialize, it should set the shared instance of the Web3Client", () async {
    await Web3Client.rawInitialize(
      automaticallyConnectWallet: false,
      browserProvider: browserProvider,
      wallet: wallet,
    );

    expect(Web3Client.shared.wallet, isNotNull);
  });

  test(
    """when the param `automaticallyConnectWallet`
      is set to true when calling `initialize`, it
      should call `connectCachedWallet` from Wallet object 
      """,
    () async {
      await Web3Client.rawInitialize(
        automaticallyConnectWallet: true,
        browserProvider: browserProvider,
        wallet: wallet,
      );

      verify(() => wallet.connectCachedWallet()).called(1);
    },
  );
}
