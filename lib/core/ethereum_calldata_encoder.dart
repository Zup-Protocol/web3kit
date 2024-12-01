import "package:hashlib/hashlib.dart";
import "package:web3kit/core/core.dart";
import "package:zup_core/zup_core.dart";

/// Encoders for getting calldata to send transactions in Ethereum
abstract class EthereumCalldataEncoder {
  /// Encode a transaction calldata given a [signature] and [params].
  ///
  /// `signature` is the signature of the function to call e.g "mint(address, uint256)".
  ///
  /// `params` is the params to pass to the function, given its signature. E.g. ["0x...", 321].
  /// In case that its a tuple, it should be a list of lists, to represent the objects,
  /// e.g. [["0x...", 321], "0x...", 321]
  ///
  /// **`Note`**: In case of non-supported types in dart, like addresses, they must be represented as strings.
  ///
  /// **`Warning`** the params must be in the same order as the signature.
  static String encodeWithSignature({
    required String signature,
    required List? params,
  }) {
    final functionSelector = keccak256.string(signature).toString().substring(0, 8);

    final paramData = _encodeParams(params ?? []);

    return "0x$functionSelector$paramData";
  }

  static String _encodeParams(List params) {
    final encodedParts = <String>[];

    for (final param in params) {
      assert(
        param is int || param is BigInt || param is String || param is List,
        "Invalid param type passed -> ${param.runtimeType}",
      );

      if (param is int) {
        (BigInt.from(param) >= EthereumConstants.uint256Max)
            ? encodedParts.add("f" * 64)
            : encodedParts.add(param.toHex().padLeft(64, param.isNegative ? "f" : "0"));
      }

      if (param is BigInt) {
        (param >= EthereumConstants.uint256Max)
            ? encodedParts.add("f" * 64)
            : encodedParts.add(param.toHex().padLeft(64, param.isNegative ? "f" : "0"));
      }

      if (param is String) {
        encodedParts.add((param.startsWith("0x") ? param.replaceAll("0x", "") : param.toHex).padLeft(64, "0"));
      }

      if (param is List) encodedParts.add(_encodeParams(param));
    }

    return encodedParts.join().replaceAll("-", "").toLowerCase();
  }
}
