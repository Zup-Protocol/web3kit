// coverage:ignore-file

import "dart:math";

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthersSigner {
  JSPromise<JSString> getAddress() => JSPromise(
        JSString(
          "0x078444A229D331085bc913f5e61ebADd1${Random().hashCode.toRadixString(16)}",
        ),
      );
}
