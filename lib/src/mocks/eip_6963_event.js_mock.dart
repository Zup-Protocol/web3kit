import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/src/mocks/eip_6963_detail.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart";

@internal
class JSEIP6963Event implements Event {
  const JSEIP6963Event([this._type = const JSString(""), this.detail = const JSEIP6963Detail()]) : super();

  final JSEIP6963Detail detail;
  final JSString _type;

  @override
  JSString get type => _type;
}
