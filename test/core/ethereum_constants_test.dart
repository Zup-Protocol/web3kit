import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/ethereum_constants.dart";

void main() {
  test("`uint256Max` should return the max value for uint256 in EVM (2^256 - 1)", () {
    expect(
      EthereumConstants.uint256Max,
      BigInt.parse("115792089237316195423570985008687907853269984665640564039457584007913129639935"),
    );
  });

  test("`uint160Max` should return the max value for uint160 in EVM (2^160 - 1)", () {
    expect(
      EthereumConstants.uint160Max,
      BigInt.parse("1461501637330902918203684832716283019655932542975"),
    );
  });

  test("`uint48Max` should return the max value for uint48 in EVM (2^48 - 1)", () {
    expect(
      EthereumConstants.uint48Max,
      BigInt.parse("281474976710655"),
    );
  });

  test("`zeroAddress` should return the correct zero address", () {
    expect(
      EthereumConstants.zeroAddress,
      "0x0000000000000000000000000000000000000000",
    );
  });

  test("`emptyBytes` should return the correct empty bytes hex string", () {
    expect(
      EthereumConstants.emptyBytes,
      "0x",
    );
  });
}
