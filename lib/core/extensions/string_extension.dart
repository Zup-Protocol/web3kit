extension StringExtension on String {
  /// Returns a shortened version of the Address.
  /// For example, 0x35570C3a17FE5b04cB3d495d253dB6C9CB838EDc -> 0x35570C...B838EDc
  String shortAddress({int prefixAndSuffixLength = 4}) {
    return "${substring(0, prefixAndSuffixLength + 2)}...${substring(length - prefixAndSuffixLength, length)}";
  }
}
