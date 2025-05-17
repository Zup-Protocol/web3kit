extension StringExtension on String {
  /// Returns a shortened version of the Address.
  /// For example, 0x35570C3a17FE5b04cB3d495d253dB6C9CB838EDc -> 0x35570C...B838EDc
  ///
  /// param `[prefixAndSuffixLength]` The length of the prefix and suffix of the address. e.g "0x1234...5678" has a length of 4
  String shortAddress({int prefixAndSuffixLength = 4}) {
    return "${substring(0, prefixAndSuffixLength + 2)}...${substring(length - prefixAndSuffixLength, length)}";
  }

  /// Returns whether the provided string is a valid ethereum address or not
  bool isEthereumAddress() {
    return RegExp(r"^0x[a-fA-F0-9]{40}$").hasMatch(this);
  }
}
