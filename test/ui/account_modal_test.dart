import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:golden_toolkit/golden_toolkit.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/web3kit.dart";
import "package:zup_core/zup_core.dart";

import "../mocks.dart";
import "golden_config.dart";

void main() {
  late Wallet wallet;
  const walletAddress = "0x99E3CfADCD8Feecb5DdF91f88998cFfB3145F78c";

  setUp(() {
    wallet = WalletMock();

    final signer = SignerMock();

    when(() => wallet.signer).thenReturn(signer);
    when(() => signer.address).thenAnswer((_) async => walletAddress);
    when(() => wallet.signerStream).thenAnswer((_) => const Stream.empty());

    when(() => wallet.disconnect()).thenAnswer((_) async {});

    mockInjections(customWallet: wallet);
  });

  tearDown(() => resetInjections());

  Future<DeviceBuilder> goldenBuilder() async => goldenDeviceBuilder(Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AccountModal.show(context);
        });

        return const SizedBox();
      }));

  zGoldenTest("Account modal golden test", goldenFileName: "account_modal", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());
  });

  zGoldenTest("When hovering the address, it should show the copy icon", goldenFileName: "account_modal_address_hover",
      (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());
    await tester.pumpAndSettle();

    await tester.hover(find.byKey(const Key("copy-address")));
    await tester.pumpAndSettle();
  });

  zGoldenTest("When click the address, it should copy the address", (tester) async {
    String? clipboardData;

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (data) {
      if (data.method == "Clipboard.setData") clipboardData = (data.arguments as Map<String, dynamic>)["text"];
      return;
    });

    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key("copy-address")));
    await tester.pumpAndSettle();

    expect(clipboardData, walletAddress);
  });

  zGoldenTest("When hovering the disconnect button, it should show the disconnect icon",
      goldenFileName: "account_modal_disconnect_hover", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());
    await tester.pumpAndSettle();

    await tester.hover(find.byKey(const Key("disconnect-wallet")));
    await tester.pumpAndSettle();
  });

  zGoldenTest("When clicking disconnect, it should disconnect the user wallet", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key("disconnect-wallet")));
    await tester.pumpAndSettle();

    verify(() => wallet.disconnect()).called(1);
  });

  zGoldenTest("When an event of disconnect is emitted (emit a null signer), it should disconnect the user wallet",
      goldenFileName: "account_modal_disconnect", (tester) async {
    final signerStreamController = StreamController<Signer?>.broadcast();
    final signerStream = signerStreamController.stream;

    when(() => wallet.signerStream).thenAnswer((_) => signerStream);

    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());
    await tester.pumpAndSettle();

    signerStreamController.add(null);
    await tester.pumpAndSettle();
  });

  zGoldenTest("If an event of signer changed is emitted, it should update the account",
      goldenFileName: "account_modal_account_changed_event", (tester) async {
    final signerStreamController = StreamController<Signer>.broadcast();
    final signerStream = signerStreamController.stream;
    final expectedNewSigner = SignerMock();
    final currentSigner = SignerMock();

    when(() => wallet.signer).thenReturn(currentSigner);
    when(() => currentSigner.address).thenAnswer((_) async => walletAddress);
    when(() => wallet.signerStream).thenAnswer((_) => signerStream);

    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());
    await tester.pumpAndSettle();

    when(() => expectedNewSigner.address).thenAnswer((_) async => "NEW_SIGNER_ADDRESS");

    signerStreamController.add(expectedNewSigner);

    await tester.pumpAndSettle();

    verify(() => expectedNewSigner.address).called(1);
    verify(() => currentSigner.address).called(1); // making sure that the past signer was being shown
  });

  zGoldenTest("If an event of signer changed is emitted, and the new signer is null, it should pop the modal",
      goldenFileName: "account_modal_account_disconnected_event", (tester) async {
    final signerStreamController = StreamController<Signer?>.broadcast();
    final signerStream = signerStreamController.stream;
    final expectedNewSigner = SignerMock();
    final currentSigner = SignerMock();

    when(() => wallet.signer).thenReturn(currentSigner);
    when(() => currentSigner.address).thenAnswer((_) async => walletAddress);
    when(() => wallet.signerStream).thenAnswer((_) => signerStream);

    await tester.pumpDeviceBuilder(await goldenBuilder(), wrapper: GoldenConfig.localizationsWrapper());
    await tester.pumpAndSettle();

    when(() => expectedNewSigner.address).thenAnswer((_) async => "NEW_SIGNER_ADDRESS");

    signerStreamController.add(null);

    await tester.pumpAndSettle();

    verify(() => currentSigner.address).called(1); // making sure that the past signer was being shown
  });
}
