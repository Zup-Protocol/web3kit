library web3kit;

import "package:flutter/foundation.dart";
import "package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart";
import "package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart";
import "package:web3kit/src/inject.dart";

export "core/core.dart";
export "src/l10n/gen/app_localizations.dart";
export "ui/ui.dart";

class Web3Kit {
  Web3Kit();

  /// Initializes the package to be able to use it.
  /// This function should be called only once
  static Future<void> initialize() async => await Inject.setup();

  /// initializes the package for running tests
  @visibleForTesting
  static Future<void> initializeForTest() async {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();

    await initialize();
  }
}
