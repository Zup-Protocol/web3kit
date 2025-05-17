import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/extensions/string_extension.dart";

void main() {
  test("When calling `shortAddress` it should return a shortened address, with '...' between the begin and end", () {
    expect("0x35570C3a17FE5b04cB3d495d253dB6C9CB838EDc".shortAddress(prefixAndSuffixLength: 6), "0x35570C...838EDc");
  });

  test("When calling 'isEtheremAddress' in a valid ethereum address, it should return true", () {
    expect("0x35570C3a17FE5b04cB3d495d253dB6C9CB838EDc".isEthereumAddress(), true);
  });

  test("When calling 'isEtheremAddress' in an invalid ethereum address, it should return false", () {
    expect("0x9087654rtghvbj765tg".isEthereumAddress(), false);
  });
}
