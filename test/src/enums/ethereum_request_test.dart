import "package:test/test.dart";
import "package:web3kit/src/enums/ethereum_request.dart";

void main() {
  test(".method extension should return the correct method string", () {
    expect(EthereumRequest.revokePermissions.method, "wallet_revokePermissions");
  });
}
