import "package:url_launcher/url_launcher.dart";

class Launcher {
  Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }
}
