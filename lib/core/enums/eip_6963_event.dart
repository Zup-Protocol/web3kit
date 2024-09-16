enum EIP6963Event { requestProvider, announceProvider }

extension EIP6963EventExtension on EIP6963Event {
  String get name => "eip6963:${toString().split('.').last}";
}
