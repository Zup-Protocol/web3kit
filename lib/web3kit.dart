library web3kit;

import "package:web3kit/src/inject.dart";

export "core/core.dart";
export "src/l10n/gen/app_localizations.dart";
export "ui/ui.dart";

class Web3Kit {
  Web3Kit();

  /// Initializes the client to be able to use it.
  /// This function should be called only once
  static Future<void> initialize() async => await Inject.setup();
}
