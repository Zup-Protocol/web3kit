import "package:flutter_test/flutter_test.dart";
import "package:web3kit/src/extensions/js_object_extension.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

void main() {
  test("the extension method `getEthereumRequestObject` should set the `method` property of the JSObject", () {
    const requestMethod = "someMethod";
    final requestParams = [
      {
        "param1": "dale".toJS,
      }
    ];
    final requestObject = JSObject().getEthereumRequestObject(requestMethod, requestParams);

    expect(((requestObject.properties["method".toJS]) as JSString).toDart, requestMethod);
  });
  test("the extension method `getEthereumRequestObject` should set the `method` property of the JSObject", () {
    const requestMethod = "someMethod";
    final requestParams = [
      {
        "param1": "dale".toJS,
      }
    ];
    final requestObject = JSObject().getEthereumRequestObject(requestMethod, requestParams);

    expect(((requestObject.properties["method".toJS]) as JSString).toDart, requestMethod);
  });
  test("the extension method `getEthereumRequestObject` should set the `method` property of the JSObject", () {
    const requestMethod = "someMethod";
    final requestParams = [
      {
        "param1": "dale".toJS,
      }
    ];

    final requestObject = JSObject().getEthereumRequestObject(requestMethod, requestParams);

    expect(((requestObject.properties["method".toJS]) as JSString).toDart, requestMethod);
  });

  test(
      "the extension method `getEthereumRequestObject` should set the `params` property if not null, but also still the `method` property",
      () {
    const requestMethod = "someMethod";
    final requestParams = [
      {
        "param1": "dale".toJS,
      }
    ];
    final requestObject = JSObject().getEthereumRequestObject(requestMethod, requestParams);

    expect(((requestObject.properties["method".toJS]) as JSString).toDart, requestMethod);
    expect(((requestObject.properties["params".toJS]) as JSArray).toDart, requestParams);
  });

  test("the extension method `getEthereumRequestObject` should not set the `params` property if null", () {
    const requestMethod = "someMethod";

    final requestObject = JSObject().getEthereumRequestObject(requestMethod, null);

    expect((requestObject.properties["params".toJS]), null);
  });
}
