import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

@internal
class JSEIP6963DetailInfo {
  const JSEIP6963DetailInfo([
    this.name = const JSString(""),
    this.icon = const JSString(""),
    this.rdns = const JSString(""),
  ]);

  final JSString name;
  final JSString icon;
  final JSString rdns;
}
