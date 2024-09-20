import "package:freezed_annotation/freezed_annotation.dart";

@internal
enum EIP6963EventEnum { requestProvider, announceProvider }

extension EIP6963EventExtension on EIP6963EventEnum {
  String get name => "eip6963:${toString().split('.').last}";
}
