import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class JSEthersSigner {
  JSPromise<JSString> getAddress() => JSPromise(const JSString("name"));
}
