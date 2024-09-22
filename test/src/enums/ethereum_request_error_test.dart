import "package:flutter_test/flutter_test.dart";
import "package:web3kit/src/enums/ethereum_request_error.dart";

void main() {
  test("When getting `code` it should return the correct code for the unrecognizedChainId", () {
    expect(EthereumRequestError.unrecognizedChainId.code, 4902);
  });
}
