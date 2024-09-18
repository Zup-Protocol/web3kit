import "package:freezed_annotation/freezed_annotation.dart";

@internal
class JS {
  final String? name;
  const JS([this.name]);
}

@internal
class JSObject {
  bool isA<T extends JSObject?>() => true;
}

@internal
typedef JSAnyRepType = Object;

@internal
class JSAny {}

@internal
class JSPromise<T> {}

@internal
class JSString<T> implements JSAny {
  final String name;
  const JSString(this.name);
}

@internal
class JSFunction {
  JSFunction(this.dartFunction);
  final Function dartFunction;
}

@internal
class JSArray<T> implements JSAny {
  JSArray(this.list);

  List<T> list;
}

@internal
extension JSPromiseToFuture<T> on JSPromise<T> {
  Future<T> get toDart => Future.value();
}

@internal
extension StringToJSString on String {
  JSString get toJS => JSString(this);
}

@internal
extension JSStringToString on JSString {
  String get toDart => name;
}

@internal
extension FunctionToJSFunction on Function {
  JSFunction get toJS => JSFunction(this);
}

@internal
extension JSArrayToList<T> on JSArray<T> {
  List<T> get toDart => list;
}

@internal
extension ListToJSArray<T> on List<T> {
  JSArray<T> jsify() => JSArray<T>(this);
}
