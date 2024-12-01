import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthersContractTransactionReceipt extends JSObject {
  JSEthersContractTransactionReceipt([this._hash = ""]);
  final String _hash;

  JSString get hash => _hash.toJS;
}
