import "package:test/test.dart";
import "package:web3kit/src/enums/ethereum_request.dart";

void main() {
  test("`.method` extension should return the correct method string for `revokePermissions`", () {
    expect(EthereumRequest.revokePermissions.method, "wallet_revokePermissions");
  });

  test("`.method` extension should return the correct method string for `switchEthereumChain`", () {
    expect(EthereumRequest.switchEthereumChain.method, "wallet_switchEthereumChain");
  });
}
