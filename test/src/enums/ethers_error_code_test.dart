import "package:test/test.dart";
import "package:web3kit/src/enums/ethers_error_code.dart";

void main() {
  test(".code extension should return the correct code string", () {
    expect(EthersError.actionRejected.code, "ACTION_REJECTED");
    expect(EthersError.unsupportedOperation.code, "UNSUPPORTED_OPERATION");
  });
}
