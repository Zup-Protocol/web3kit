import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:golden_toolkit/golden_toolkit.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/web3kit.dart";
import "package:zup_core/zup_core.dart";
import "package:zup_ui_kit/buttons/zup_primary_button.dart";

import "../mocks.dart";
import "golden_config.dart";

void main() {
  late Wallet wallet;

  setUp(() {
    registerFallbackValue(WalletDetailMock());
    wallet = WalletMock();
    mockInjections(customWallet: wallet);

    when(() => wallet.signerStream).thenAnswer((_) => const Stream.empty());
    when(() => wallet.installedWallets).thenReturn([]);
  });

  tearDown(() => resetInjections());

  Future<DeviceBuilder> goldenBuilder({
    Color? backgroundColor,
    Color? foregroundColor,
    Widget? customIcon,
    dynamic Function(Signer)? onConnectWallet,
    bool compact = false,
    double? height,
  }) async =>
      await goldenDeviceBuilder(ConnectButton(
          backgroundColor: backgroundColor,
          customIcon: customIcon,
          foregroundColor: foregroundColor,
          compact: compact,
          height: height,
          onConnectWallet: onConnectWallet ?? (Signer signer) {}));

  zGoldenTest("Connect button should use Zup UI Kit button if no account is connect", goldenFileName: "connect_button",
      (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder());

    expect(find.byType(ZupPrimaryButton), findsOneWidget);
  });

  zGoldenTest("When there is no account connected, the click in the button should show the connect wallet modal",
      goldenFileName: "connect_button_tap", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());

    await tester.tap(find.byKey(const Key("connect-button")));
  });

  zGoldenTest("When setting the background color should change the color of the button",
      goldenFileName: "connect_button_background_color", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(backgroundColor: Colors.red),
        wrapper: GoldenConfig.localizationsWrapper());
  });

  zGoldenTest("When setting the custom icon, it should change the icon on hover",
      goldenFileName: "connect_button_custom_icon_hover", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(customIcon: const Icon(Icons.dialer_sip)),
        wrapper: GoldenConfig.localizationsWrapper());

    await tester.hover(find.byKey(const Key("connect-button")));
  });

  zGoldenTest("When setting the foreground color, it should change the text color of the button",
      goldenFileName: "connect_button_custom_foreground_color", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(foregroundColor: Colors.pink),
        wrapper: GoldenConfig.localizationsWrapper());

    await tester.hover(find.byKey(const Key("connect-button")));
  });
  autoUpdateGoldenFiles = true;
  zGoldenTest(
      "When the signer event is emitted, and the signer is not null, it should switch to connected wallet button",
      goldenFileName: "connect_button_connected_signer_event", (tester) async {
    final StreamController<Signer?> signerStreamController = StreamController<Signer>.broadcast();
    final signerStream = signerStreamController.stream;
    final connectedSigner = SignerMock();

    when(() => wallet.signerStream).thenAnswer((_) => signerStream);
    when(() => connectedSigner.address).thenAnswer((_) async => "0x99E3CfADCD8Feecb5DdF91f88998cFfB3145F78c");
    await tester.pumpDeviceBuilder(await goldenBuilder());

    signerStreamController.add(connectedSigner);

    await tester.pumpAndSettle();
  });

  zGoldenTest(
      "When the signer event is emitted, the signer is null, and the state is connected it should switch to connect button",
      goldenFileName: "connect_button_disconnected_signer_event", (tester) async {
    final StreamController<Signer?> signerStreamController = StreamController<Signer?>.broadcast();
    final signerStream = signerStreamController.stream;
    final connectedSigner = SignerMock();

    when(() => wallet.signerStream).thenAnswer((_) => signerStream);
    when(() => connectedSigner.address).thenAnswer((_) async => "0x99E3CfADCD8Feecb5DdF91f88998cFfB3145F78c");
    await tester.pumpDeviceBuilder(await goldenBuilder());

    signerStreamController.add(connectedSigner);
    await tester.pumpAndSettle();

    expect(find.byType(ConnectedWalletButton), findsOneWidget); // make sure that it is connected

    signerStreamController.add(null);
    await tester.pumpAndSettle();
  });

  zGoldenTest("When connecting the wallet with the button flow, it should callback with the signer", (tester) async {
    final expectedConnectedSigner = SignerMock();
    Signer? connectedSigner;

    when(() => wallet.installedWallets).thenReturn([
      WalletDetail(
          info: const WalletInfo(name: "name", icon: "icon", rdns: "rdns"),
          provider: EthereumProvider(JSEthereumProviderMock()))
    ]);

    when(() => wallet.connect(any())).thenAnswer((_) async => expectedConnectedSigner);

    await tester.pumpDeviceBuilder(
      await goldenBuilder(
        onConnectWallet: (signer) => connectedSigner = signer,
      ),
      wrapper: GoldenConfig.localizationsWrapper(),
    );

    await tester.tap(find.byKey(const Key("connect-button")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key("wallet-button-0")));
    await tester.pumpAndSettle();

    expect(connectedSigner, expectedConnectedSigner);
  });

  zGoldenTest(
    "When passing compact true, it should show a compact button",
    goldenFileName: "connect_button_compact",
    (tester) async {
      await tester.pumpDeviceBuilder(await goldenBuilder(compact: true));
    },
  );

  zGoldenTest(
    "When setting a custom height for a compact button, it should set the height of the button",
    goldenFileName: "connect_button_custom_height_compact",
    (tester) async {
      await tester.pumpDeviceBuilder(await goldenBuilder(compact: true, height: 100));
    },
  );

  zGoldenTest(
    "When setting a custom height for the button, it should set the height of the button",
    goldenFileName: "connect_button_custom_height",
    (tester) async {
      await tester.pumpDeviceBuilder(await goldenBuilder(height: 100));
    },
  );
}
