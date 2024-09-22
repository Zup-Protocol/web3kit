import "package:freezed_annotation/freezed_annotation.dart";

@internal
enum EthereumRequest { revokePermissions, switchEthereumChain }

extension EthereumRequestExtension on EthereumRequest {
  String get method => ["wallet_revokePermissions", "wallet_switchEthereumChain"][index];
}