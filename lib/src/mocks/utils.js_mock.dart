import "package_mocks/js_interop_mock.dart";

JSBigInt createJSBigInt(JSString value) {
  return JSBigInt(int.parse(value.toDart));
}
