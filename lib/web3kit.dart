library web3kit;

import "dart:js_interop";

extension type Window(JSObject _) implements JSObject {}

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
