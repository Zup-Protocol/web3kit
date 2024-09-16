enum EthereumRequest { revokePermissions }

extension EthereumRequestExtension on EthereumRequest {
  String get method => ["wallet_revokePermissions"][index];
}
