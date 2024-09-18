import "package:equatable/equatable.dart";
import "package:freezed_annotation/freezed_annotation.dart";

@internal
class JS {
  final String? name;
  const JS([this.name]);
}

@internal
class JSObject extends Equatable {
  bool isA<T extends JSObject?>() => true;

  final Map<JSAny, JSAny?> properties = {};

  @override
  List<Object?> get props => [properties];
}

@internal
typedef JSAnyRepType = Object;

@internal
class JSAny {}

@internal
class JSPromise<T> {
  JSPromise(this.value);

  T value;
}

@internal
class JSString<T> extends Equatable implements JSAny {
  final String name;
  const JSString(this.name);

  @override
  List<Object?> get props => [name];
}

@internal
class JSFunction {
  JSFunction(this.dartFunction);
  final Function dartFunction;
}

@internal
class JSArray<T> extends Equatable implements JSAny {
  JSArray(this.list);

  List<T> list;

  @override
  List<Object?> get props => [list];
}

@internal
extension JSPromiseToFuture<T> on JSPromise<T> {
  Future<T> get toDart async => await Future.value(value);
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
