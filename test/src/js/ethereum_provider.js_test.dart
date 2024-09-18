import "package:test/test.dart";
import "package:web3kit/src/js/ethereum_provider.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

@JS("JSEthereumProvider")
class JSHH {}

void main() {
  test("description", () {
    JSEthereumProvider();
  });
}
