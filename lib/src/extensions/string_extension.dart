extension StringExtension on String {
  String get toPascalCase {
    return split(RegExp(r"[_-]")).map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join();
  }

  String get removeUnderScores => replaceAll("_", "");
}
