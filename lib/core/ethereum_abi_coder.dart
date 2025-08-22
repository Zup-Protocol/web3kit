import "package:web3kit/src/extensions/bigint_extension.dart";
import "package:web3kit/src/extensions/list_extension.dart";
import "package:web3kit/src/js/ethers/ethers_abi_coder.js.dart";
import "package:web3kit/src/js/ethers/ethers_solidity_packed.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

/// Encoding and decoding functions for Ethereum ABI data
/// Work for encoding and decoding any type of data supported by the Ethereum ABI,
/// working the same as the Solidity compiler (abi.encode;abi.decode, etc.)
class EthereumAbiCoder {
  /// Encode a list of values to a packed ABI encoded string.
  ///
  /// Accepts a list of types and a list of values and returns a packed ABI encoded string.
  /// Works the same as Solidity's `abi.encodePacked` function.
  ///
  /// What's packed encoding? Concatenate values in their minimal binary form without padding them to 32 bytes
  ///
  /// E.g encoding a uint8: 10 -> 0x0a
  String encodePacked(List<String> types, List<dynamic> values) {
    return ethersSolidityPacked(types.toJS, values.jsify() as JSArray<JSAny>).toDart;
  }

  /// Encode a list of values to an ABI encoded string of 32 bytes.
  ///
  /// Accepts a list of types and a list of values and returns an ABI encoded string.
  /// Works the same as Solidity's `abi.encode` function.
  ///
  /// E.g encoding 10 -> 0x000000000000000000000000000000000000000000000000000000000000000a
  String encode(List<String> types, List<dynamic> values) {
    final coder = JSEthersAbiCoder();

    // ignore: unnecessary_cast
    return coder.encode(types.toJS, _parseListToJSTypedList(values).jsify() as JSArray<JSAny>).toDart;
  }

  List<JSAny> _parseListToJSTypedList(List<dynamic> values) {
    // ignore: unnecessary_cast
    final List<JSAny> jsTypedArray = values.map((value) {
      if (value is BigInt) {
        return value.toJS;
      } else if (value is String) {
        return value.toJS;
      } else if (value is List) {
        // ignore: unnecessary_cast
        return _parseListToJSTypedList(value).jsify() as JSArray<JSAny>;
      } else if (value is int) {
        return value.toJS;
      } else {
        throw ArgumentError("Unsupported value type: ${value.runtimeType}");
      }
    }).toList();

    return jsTypedArray;
  }
}
