import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/ethereum_calldata_encoder.dart";

void main() {
  test(
    "`encodeWithSignature` should return a valid calldata for EVM",
    () {
      final calldata = EthereumCalldataEncoder.encodeWithSignature(
        signature: "mint(address, uint256, uint256, (uint256, uint256, address))",
        params: [
          "0x0x3A3Bcb3b225d0e672C6066389207F3DcAF9aF49F",
          BigInt.from(23),
          321,
          [
            BigInt.from(23),
            321,
            "0x0x3A3Bcb3b225d0e672C6066389207F3DcAF9aF49F",
          ]
        ],
      );

      expect(
        calldata,
        "0xb6f264c60000000000000000000000003a3bcb3b225d0e672c6066389207f3dcaf9af49f00000000000000000000000000000000000000000000000000000000000000170000000000000000000000000000000000000000000000000000000000000141000000000000000000000000000000000000000000000000000000000000001700000000000000000000000000000000000000000000000000000000000001410000000000000000000000003a3bcb3b225d0e672c6066389207f3dcaf9af49f",
      );
    },
  );
}
