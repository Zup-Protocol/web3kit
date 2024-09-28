import "package:equatable/equatable.dart";
import "package:freezed_annotation/freezed_annotation.dart";

@internal
class JS {
  final String? name;
  const JS([this.name]);
}

@internal
class JSObject extends Equatable implements JSAny {
  bool isA<T extends JSObject?>() => true;

  /// Warning: THIS FUNCTION DOES NOT EXIST IN THE REAL IMPLEMENTATION. ONLY IN THE MOCK
  @internal
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

  @visibleForTesting
  T value;
}

@internal
class JSString<T> extends Equatable implements JSAny {
  @visibleForTesting
  final String name;

  const JSString(this.name);

  @override
  List<Object?> get props => [name];
}

@internal
class JSFunction {
  JSFunction(this.dartFunction);

  /// Warning: THIS FUNCTION DOES NOT EXIST IN THE REAL IMPLEMENTATION. ONLY IN THE MOCK
  @internal
  final Function dartFunction;
}

@internal
class JSArray<T> extends Equatable implements JSAny {
  const JSArray(this.list);

  @visibleForTesting
  final List<T> list;

  @override
  List<Object?> get props => [list];
}

@internal
class JSNumber extends Equatable implements JSAny {
  const JSNumber(this.value);

  @visibleForTesting
  final num value;

  @override
  List<Object?> get props => [value];
}

@internal
class JSBigInt implements JSAny {
  JSBigInt(this.value);

  int value;

  @override
  String toString() {
    return value.toString();
  }
}

extension JSBigIntToObject on JSBigInt {
  Object? dartify() => null;
}

@internal
extension JSPromiseToFuture<T> on JSPromise<T> {
  Future<T> get toDart async {
    await Future.delayed(const Duration(milliseconds: 0));
    return await Future.value(value);
  }
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

@internal
extension JSNumberToInt on JSNumber {
  int get toDartInt => value.toInt();
}

@internal
extension IntToJSNumber on int {
  JSNumber get toJS => JSNumber(this);
}
