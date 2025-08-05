import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:golden_toolkit/golden_toolkit.dart";
import "package:web3kit/web3kit.dart";

import "../mocks.dart";

class GoldenConfig {
  static final smallSquareDevice = [const Device(size: Size(800, 800), name: "square")];
  static final phoneDevice = [const Device(size: Size(375, 812), name: "phone")];

  static Future<Widget> builder(Widget child) async {
    await loadAppFonts();

    return MaterialApp(
      localizationsDelegates: const [Web3KitLocalizations.delegate],
      home: Scaffold(body: Center(child: child)),
    );
  }

  static Widget Function(Widget) localizationsWrapper() {
    return (child) => MaterialApp(localizationsDelegates: const [Web3KitLocalizations.delegate], home: child);
  }
}

Future<DeviceBuilder> goldenDeviceBuilder(Widget child, {bool phoneDevice = false}) async => DeviceBuilder()
  ..overrideDevicesForAllScenarios(devices: phoneDevice ? GoldenConfig.phoneDevice : GoldenConfig.smallSquareDevice)
  ..addScenario(widget: await GoldenConfig.builder(child));

@isTest
void zGoldenTest(
  String description,
  Future<void> Function(WidgetTester tester) test, {
  String? goldenFileName,
  Uint8List? overrideMockedNetworkImage,
}) {
  return testGoldens(description, (tester) async {
    await mockHttpImage(() async => await test(tester), overrideImage: overrideMockedNetworkImage);

    await tester.pumpAndSettle();

    if (goldenFileName != null) {
      try {
        await screenMatchesGolden(tester, goldenFileName);
      } catch (e) {
        if ((e as TestFailure).message!.contains("non-existent file")) {
          autoUpdateGoldenFiles = true;
          await screenMatchesGolden(tester, goldenFileName);
          autoUpdateGoldenFiles = false;

          // ignore: avoid_print
          print("Golden file not detected. Auto-generated golden file: $goldenFileName");

          return;
        }

        rethrow;
      }
    }
  });
}
