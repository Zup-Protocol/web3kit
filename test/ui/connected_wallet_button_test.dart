import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:golden_toolkit/golden_toolkit.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/web3kit.dart";

import "../mocks.dart";
import "golden_config.dart";

void main() {
  late Signer signer;
  late BrowserProvider browserProvider;
  late Wallet wallet;

  setUp(() {
    signer = SignerMock();
    browserProvider = BrowserProviderMock();
    wallet = WalletMock();

    mockInjections(customBrowserProvider: browserProvider, customWallet: wallet);

    when(() => wallet.signerStream).thenAnswer((_) => const Stream.empty());
    when(() => wallet.signerStream).thenAnswer((_) => const Stream.empty());
    when(() => signer.address).thenAnswer((_) async => "0x99E3CfADCD8Feecb5DdF91f88998cFfB3145F78c");
  });

  tearDown(() => resetInjections());

  Future<DeviceBuilder> goldenBuilder({Signer? customSigner, bool? compact}) async => goldenDeviceBuilder(Center(
        child: ConnectedWalletButton(
          signer: customSigner ?? signer,
          width: 300,
          height: 60,
          compact: compact ?? false,
        ),
      ));

  zGoldenTest("When initializing, it should get the signer address", goldenFileName: "connected_wallet_button",
      (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder());

    verify(() => signer.address).called(1);
  });

  zGoldenTest("When an error occurs, it should show the error state", goldenFileName: "connected_wallet_button_error",
      (tester) async {
    when(() => signer.address).thenThrow("error");

    await tester.pumpDeviceBuilder(await goldenBuilder());
  });

  zGoldenTest("When the signer changes (an event is emitted), it should get the new signer",
      goldenFileName: "connected_wallet_button_event_emitted", (tester) async {
    final streamController = StreamController<Signer>();
    final stream = streamController.stream;
    final emittedSigner = SignerMock();

    when(() => wallet.signerStream).thenAnswer((_) => stream);
    when(() => emittedSigner.address).thenAnswer((_) async => "0x0123456eventEmitted");

    await tester.pumpDeviceBuilder(await goldenBuilder());

    streamController.add(emittedSigner);

    await tester.pumpAndSettle();

    verify(() => emittedSigner.address).called(1);
  });

  zGoldenTest("When the signer changes to null, it should not get the new signer",
      goldenFileName: "connected_wallet_button_event_emitted_null", (tester) async {
    final streamController = StreamController<Signer?>();
    final stream = streamController.stream;

    when(() => wallet.signerStream).thenAnswer((_) => stream);

    await tester.pumpDeviceBuilder(await goldenBuilder());

    streamController.add(null);

    await tester.pumpAndSettle();
  });

  zGoldenTest("When the signer emits an event to the same signer, it should not get the signer again",
      goldenFileName: "connected_wallet_button_event_emitted_same", (tester) async {
    final streamController = StreamController<Signer>();
    final stream = streamController.stream;

    when(() => wallet.signerStream).thenAnswer((_) => stream);

    await tester.pumpDeviceBuilder(await goldenBuilder());

    streamController.add(signer);

    await tester.pumpAndSettle();

    verify(() => signer.address).called(1); // 1 call because of the initial call
  });

  zGoldenTest("When getting the signer, if an ENS name is available, it should use it",
      goldenFileName: "connected_wallet_button_ens_available", (tester) async {
    when(() => signer.ensName).thenAnswer((_) async => "dale.eth");

    await tester.pumpDeviceBuilder(await goldenBuilder());

    verify(() => signer.ensName).called(1);
  });

  zGoldenTest("When getting the signer, if the ENS call fail, it should use the address",
      goldenFileName: "connected_wallet_button_no_ens", (tester) async {
    when(() => signer.ensName).thenThrow("no ens bro");

    await tester.pumpDeviceBuilder(await goldenBuilder());

    verify(() => signer.ensName).called(1);
  });

  zGoldenTest("When tapping the button, it should open the account modal",
      goldenFileName: "connected_wallet_button_click", (tester) async {
    final signer = SignerMock();
    when(() => wallet.signer).thenReturn(signer);
    when(() => signer.address).thenAnswer((_) async => "0x99E3CfADCD8Feecb5DdF91f88998cFfB3145F78c");

    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());

    await tester.tap(find.byKey(const Key("connected-wallet-button")));
    await tester.pumpAndSettle();
  });

  zGoldenTest("When passing compact true, the button should be compact (show only the avatar)",
      goldenFileName: "connected_wallet_button_compact", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(customSigner: signer, compact: true));

    await tester.pumpAndSettle();

    expect(find.byType(ConnectedWalletButton), findsOneWidget);
  });
}
