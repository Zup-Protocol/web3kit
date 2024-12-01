import "package:flutter_test/flutter_test.dart";
import "package:web3kit/src/extensions/string_extension.dart";

void main() {
  test("`removeUnderscores` should remove all underscores from a string", () {
    expect("test_string".removeUnderScores, "teststring");
  });
}
