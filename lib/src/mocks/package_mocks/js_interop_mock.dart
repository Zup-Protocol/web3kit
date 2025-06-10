// coverage:ignore-file

import "package:equatable/equatable.dart";
import "package:freezed_annotation/freezed_annotation.dart";

class JS {
  final String? name;
  const JS([this.name]);
}

class JSObject extends Equatable implements JSAny {
  bool isA<T extends JSObject?>() => true;

  /// Warning: THIS FUNCTION DOES NOT EXIST IN THE REAL IMPLEMENTATION. ONLY IN THE MOCK

  final Map<JSAny, JSAny?> properties = {};

  @override
  List<Object?> get props => [properties];
}

typedef JSAnyRepType = Object;

class JSAny {}

class JSPromise<T> {
  JSPromise(this.value);

  @visibleForTesting
  T value;
}

class JSString extends Equatable implements JSAny {
  @visibleForTesting
  final String name;

  const JSString(this.name);

  @override
  List<Object?> get props => [name];
}

class JSBoolean implements JSAny {
  @visibleForTesting
  final bool value;

  const JSBoolean(this.value);
}

class JSFunction {
  JSFunction(this.dartFunction);

  /// Warning: THIS FUNCTION DOES NOT EXIST IN THE REAL IMPLEMENTATION. ONLY IN THE MOCK
  final Function dartFunction;
}

class JSArray<T> extends Equatable implements JSAny {
  const JSArray(this.list);

  @visibleForTesting
  final List<T> list;

  @override
  List<Object?> get props => [list];
}

class JSNumber extends Equatable implements JSAny {
  const JSNumber(this.value);

  @visibleForTesting
  final num value;

  @override
  List<Object?> get props => [value];
}

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

extension JSPromiseToFuture<T> on JSPromise<T> {
  Future<T> get toDart async {
    await Future.delayed(const Duration(milliseconds: 0));
    return await Future.value(value);
  }
}

extension StringToJSString on String {
  JSString get toJS => JSString(this);
}

extension JSStringToString on JSString {
  String get toDart => name;
}

extension JSBooleanToBool on JSBoolean {
  bool get toDart => true;
}

extension FunctionToJSFunction on Function {
  JSFunction get toJS => JSFunction(this);
}

extension JSArrayToList<T> on JSArray<T> {
  List<T> get toDart => list;
}

extension ListToJSArray<T> on List<T> {
  JSArray<T> jsify() => JSArray<T>(this);
}

extension JSNumberToInt on JSNumber {
  int get toDartInt => value.toInt();
}

extension IntToJSNumber on int {
  JSNumber get toJS => JSNumber(this);
}

extension BoolToJSBoolean on bool {
  JSBoolean get toJS => JSBoolean(this);
}

extension IterableToJS on Iterable {
  List<JSAny> jsify() => map((e) => e.jsify()).toList() as List<JSAny>;
}

extension NullableObjectUtilExtension on Object? {
  JSAny? jsify() => this as JSAny;
}
