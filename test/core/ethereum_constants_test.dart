import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/ethereum_constants.dart";

void main() {
  test("`uint256Max` should return the max value for uint256 in EVM (2^256 - 1)", () {
    expect(
      EthereumConstants.uint256Max,
      BigInt.parse("115792089237316195423570985008687907853269984665640564039457584007913129639935"),
    );
  });
}
