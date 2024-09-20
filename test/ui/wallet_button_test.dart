import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_test/flutter_test.dart";
import "package:golden_toolkit/golden_toolkit.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/ethers/ethers_exceptions.dart";
import "package:web3kit/ui/wallet_button.dart";

import "../mocks.dart";
import "golden_config.dart";
import "helpers.dart";

void main() {
  late WalletMock wallet;
  late EthereumProvider ethereumProvider;
  late WalletDetail walletDetail;

  setUp(() async {
    ethereumProvider = EthereumProviderMock();
    walletDetail = WalletDetail(
      info: const WalletInfo(name: "Wallet Name", icon: "icon", rdns: "rdns"),
      provider: ethereumProvider,
    );
    wallet = WalletMock();

    registerFallbackValue(walletDetail);

    when(() => wallet.installedWallets).thenReturn([walletDetail]);
    when(() => wallet.connect(any())).thenAnswer((_) async => SignerMock());

    mockInjections(customWallet: wallet);
  });

  tearDown(() => resetInjections());

  Future<DeviceBuilder> goldenBuilder({Function(Signer singer)? onConnect, WalletDetail? customWalletDetail}) async =>
      await goldenDeviceBuilder(WalletButton(
        walletDetail: customWalletDetail ?? walletDetail,
        onConnect: onConnect ?? (wallet) {},
        width: 300,
      ));

  zGoldenTest(
    "Installed wallet",
    goldenFileName: "wallet_button_wallet_installed",
    (tester) async {
      await tester.pumpDeviceBuilder(await goldenBuilder());
    },
  );

  zGoldenTest(
    "Not Installed wallet",
    goldenFileName: "wallet_button_wallet_not_installed",
    (tester) async {
      when(() => wallet.installedWallets).thenReturn([]);

      await tester.pumpDeviceBuilder(await goldenBuilder());
    },
  );

  zGoldenTest(
    "Hovering",
    goldenFileName: "wallet_button_hovering",
    (tester) async {
      when(() => wallet.installedWallets).thenReturn([]);

      await tester.pumpDeviceBuilder(await goldenBuilder());

      await tester.hover(find.byKey(const Key("wallet-button")));

      await tester.pumpAndSettle();
    },
  );

  zGoldenTest("When clicking the button, it should try to connect the wallet", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder());

    await tester.tap(find.byKey(const Key("wallet-button")));
    await tester.pumpAndSettle();

    verify(() => wallet.connect(walletDetail)).called(1);
  });

  zGoldenTest("When click the button, and the wallet connection succeed, it should call the callback with the signer",
      (tester) async {
    final expectedSigner = SignerMock();
    when(() => wallet.connect(any())).thenAnswer((_) async => expectedSigner);
    Signer? actualConnectedSigner;
    await tester.pumpDeviceBuilder(await goldenBuilder(
      onConnect: (singer) => actualConnectedSigner = singer,
    ));

    await tester.tap(find.byKey(const Key("wallet-button")));
    await tester.pumpAndSettle();

    expect(actualConnectedSigner!.hashCode, expectedSigner.hashCode);
  });

  zGoldenTest("When click the button, and the connection throws an `UserRejectedAction` error, it should do nothing",
      goldenFileName: "wallet_button_user_rejected", (tester) async {
    when(() => wallet.connect(any())).thenThrow(UserRejectedAction());

    await tester.pumpDeviceBuilder(await goldenBuilder());

    await tester.tap(find.byKey(const Key("wallet-button")));
    await tester.pumpAndSettle();
  });

  zGoldenTest(
      "When click the button, and the connection throws an error that is not `UserRejectedAction`, it should show a snack bar",
      goldenFileName: "wallet_button_error", (tester) async {
    when(() => wallet.connect(any())).thenThrow("Other error");

    await tester.pumpDeviceBuilder(await goldenBuilder());

    await tester.tap(find.byKey(const Key("wallet-button")));
    await tester.pumpAndSettle();
  });

  zGoldenTest("When the wallet icon is SVG, it should use SVGPicture to render the icon",
      overrideMockedNetworkImage: base64Decode(
          "PHN2ZyB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMTYiIGN5PSIxNiIgcj0iMTMiIGZpbGw9IndoaXRlIi8+CjxwYXRoIGQ9Ik0xNi4wMDAxIDIyLjkxMDhDMTcuNTMwOSAyMi45MTA4IDE4Ljc3MTggMjEuNjY5OSAxOC43NzE4IDIwLjEzOTFDMTguNzcxOCAxOC42MDg0IDE3LjUzMDkgMTcuMzY3NCAxNi4wMDAxIDE3LjM2NzRDMTQuNDY5MyAxNy4zNjc0IDEzLjIyODQgMTguNjA4NCAxMy4yMjg0IDIwLjEzOTFDMTMuMjI4NCAyMS42Njk5IDE0LjQ2OTMgMjIuOTEwOCAxNi4wMDAxIDIyLjkxMDhaIiBmaWxsPSJibGFjayIvPgo8cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGNsaXAtcnVsZT0iZXZlbm9kZCIgZD0iTTE2IDMyQzI3LjA0NTcgMzIgMzIgMjcuMDQ1NyAzMiAxNkMzMiA0Ljk1NDMgMjcuMDQ1NyAwIDE2IDBDNC45NTQzIDAgMCA0Ljk1NDMgMCAxNkMwIDI3LjA0NTcgNC45NTQzIDMyIDE2IDMyWk0xMi45OTQ1IDYuNzg0NTdIMTcuNDQ1NlYxNC4xMTk2SDE0LjY4NTlWOS4xNDU4M0gxMi4yMTM2TDEyLjk5NDUgNi43ODQ1N1pNMTYuMDAwMSAyNS4yMTU0QzE4LjgwMzcgMjUuMjE1NCAyMS4wNzY0IDIyLjk0MjcgMjEuMDc2NCAyMC4xMzkxQzIxLjA3NjQgMTcuMzM1NiAxOC44MDM3IDE1LjA2MjggMTYuMDAwMSAxNS4wNjI4QzEzLjE5NjUgMTUuMDYyOCAxMC45MjM4IDE3LjMzNTYgMTAuOTIzOCAyMC4xMzkxQzEwLjkyMzggMjIuOTQyNyAxMy4xOTY1IDI1LjIxNTQgMTYuMDAwMSAyNS4yMTU0WiIgZmlsbD0iYmxhY2siLz4KPC9zdmc+Cg=="),
      goldenFileName: "wallet_button_svg_wallet_icon", (tester) async {
    final customWalletDetail = WalletDetail(
        info: const WalletInfo(
          name: "Test",
          icon:
              "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMTYiIGN5PSIxNiIgcj0iMTMiIGZpbGw9IndoaXRlIi8+CjxwYXRoIGQ9Ik0xNi4wMDAxIDIyLjkxMDhDMTcuNTMwOSAyMi45MTA4IDE4Ljc3MTggMjEuNjY5OSAxOC43NzE4IDIwLjEzOTFDMTguNzcxOCAxOC42MDg0IDE3LjUzMDkgMTcuMzY3NCAxNi4wMDAxIDE3LjM2NzRDMTQuNDY5MyAxNy4zNjc0IDEzLjIyODQgMTguNjA4NCAxMy4yMjg0IDIwLjEzOTFDMTMuMjI4NCAyMS42Njk5IDE0LjQ2OTMgMjIuOTEwOCAxNi4wMDAxIDIyLjkxMDhaIiBmaWxsPSJibGFjayIvPgo8cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGNsaXAtcnVsZT0iZXZlbm9kZCIgZD0iTTE2IDMyQzI3LjA0NTcgMzIgMzIgMjcuMDQ1NyAzMiAxNkMzMiA0Ljk1NDMgMjcuMDQ1NyAwIDE2IDBDNC45NTQzIDAgMCA0Ljk1NDMgMCAxNkMwIDI3LjA0NTcgNC45NTQzIDMyIDE2IDMyWk0xMi45OTQ1IDYuNzg0NTdIMTcuNDQ1NlYxNC4xMTk2SDE0LjY4NTlWOS4xNDU4M0gxMi4yMTM2TDEyLjk5NDUgNi43ODQ1N1pNMTYuMDAwMSAyNS4yMTU0QzE4LjgwMzcgMjUuMjE1NCAyMS4wNzY0IDIyLjk0MjcgMjEuMDc2NCAyMC4xMzkxQzIxLjA3NjQgMTcuMzM1NiAxOC44MDM3IDE1LjA2MjggMTYuMDAwMSAxNS4wNjI4QzEzLjE5NjUgMTUuMDYyOCAxMC45MjM4IDE3LjMzNTYgMTAuOTIzOCAyMC4xMzkxQzEwLjkyMzggMjIuOTQyNyAxMy4xOTY1IDI1LjIxNTQgMTYuMDAwMSAyNS4yMTU0WiIgZmlsbD0iYmxhY2siLz4KPC9zdmc+Cg==",
          rdns: "",
        ),
        provider: EthereumProviderMock());

    await tester.pumpDeviceBuilder(await goldenBuilder(customWalletDetail: customWalletDetail));
    expect(find.byType(SvgPicture), findsOneWidget);

    await tester.pumpAndSettle();
  });

  zGoldenTest("When the wallet icon is not SVG, it should use Image widget to render the icon",
      goldenFileName: "wallet_button_image_wallet_icon", (tester) async {
    final customWalletDetail = WalletDetail(
        info: const WalletInfo(
          name: "Test",
          icon: "icon",
          rdns: "",
        ),
        provider: EthereumProviderMock());

    await tester.pumpDeviceBuilder(await goldenBuilder(customWalletDetail: customWalletDetail));

    expect(find.byType(Image), findsOneWidget);
  });
}
