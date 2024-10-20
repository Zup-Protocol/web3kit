import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

@internal
extension JSObjectUnsafeUtilExtension on JSObject {
  void setProperty(JSAny property, JSAny? value) {
    properties[property] = value;
  }

  R getProperty<R extends JSAny?>(JSAny property) {
    return properties[property] as R;
  }
}
