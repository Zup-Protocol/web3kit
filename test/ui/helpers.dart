import "package:flutter/gestures.dart";
import "package:flutter_test/flutter_test.dart";

extension WidgetTesterExtension on WidgetTester {
  Future<void> hover(Finder find) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);

    await gesture.moveTo(getCenter(find));
  }

  Future<void> unHover(Finder find) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);

    gesture.cancel();
  }
}
