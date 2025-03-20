import "package:mocktail/mocktail.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:test/test.dart";
import "package:web3kit/src/cache.dart";

import "../mocks.dart";

void main() {
  late Cache sut;
  late SharedPreferencesWithCache sharedPreferencesWithCache;

  setUp(() {
    sharedPreferencesWithCache = SharedPreferencesWithCacheMock();
    sut = Cache(sharedPreferencesWithCache);

    when(() => sharedPreferencesWithCache.setString(any(), any())).thenAnswer((_) async => true);
  });

  test("when calling `setWalletConnectionState` it should store the string passed with shared preferences", () async {
    const string = "test";
    await sut.setWalletConnectionState(string);

    verify(() => sharedPreferencesWithCache.setString(CacheKey.connectedWallet.key, string)).called(1);
  });

  test("when calling `getConnectedWallet` it should get the stored string with shared preferences", () async {
    const expectedString = "test";

    when(() => sharedPreferencesWithCache.getString(any())).thenReturn(expectedString);

    final returnedString = await sut.getConnectedWallet();

    expect(returnedString, expectedString);
    verify(() => sharedPreferencesWithCache.getString(CacheKey.connectedWallet.key)).called(1);
  });

  test("When calling `.keys` method in the cache key enum, it should return all the cache keys as Set", () {
    expect(CacheKey.keys, CacheKey.values.map((key) => key.key).toSet());
  });
}
