import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

extension StringListExtension on List<String> {
  JSArray<JSString> get toJS => jsify() as JSArray<JSString>;
}
