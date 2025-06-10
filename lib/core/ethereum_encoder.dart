import "package:web3kit/src/extensions/bigint_extension.dart";
import "package:web3kit/src/extensions/list_extension.dart";
import "package:web3kit/src/js/ethers/ethers_abi_coder.js.dart";
import "package:web3kit/src/js/ethers/ethers_solidity_packed.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

class EthereumEncoder {
  static String encodePacked(List<String> types, List<dynamic> values) {
    return ethersSolidityPacked(types.toJS, values.jsify() as JSArray<JSAny>).toDart;
  }

  static String encode(List<String> types, List<dynamic> values) {
    final coder = JSEthersAbiCoder();

    // ignore: unnecessary_cast
    return coder.encode(types.toJS, _parseListToJSTypedList(values).jsify() as JSArray<JSAny>).toDart;
  }

  static List<JSAny> _parseListToJSTypedList(List<dynamic> values) {
    // ignore: unnecessary_cast
    final List<JSAny> jsTypedArray = values.map((value) {
      if (value is BigInt) {
        return value.toJS;
      } else if (value is String) {
        return value.toJS;
      } else if (value is List) {
        // ignore: unnecessary_cast
        return _parseListToJSTypedList(value).jsify() as JSArray<JSAny>;
      } else {
        throw ArgumentError("Unsupported value type: ${value.runtimeType}");
      }
    }).toList() as List<JSAny>;

    return jsTypedArray;
  }
}
