import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:golden_toolkit/golden_toolkit.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/ui/connect_modal.dart";

import "../mocks.dart";
import "golden_config.dart";

void main() {
  late BrowserProvider browserProvider;
  late Wallet wallet;

  setUp(() {
    registerFallbackValue(
      WalletDetail(info: const WalletInfo(name: "", icon: "icon", rdns: "rdns"), provider: EthereumProviderMock()),
    );
    browserProvider = BrowserProviderMock();
    wallet = WalletMock();

    Web3Client.rawInitialize(automaticallyConnectWallet: false, browserProvider: browserProvider, wallet: wallet);

    when(() => wallet.installedWallets).thenReturn([]);
  });

  tearDown(() => Web3Client.dispose());

  Future<DeviceBuilder> goldenBuilder({dynamic Function(Signer)? onConnectWallet}) =>
      goldenDeviceBuilder(ConnectModal(onConnectWallet: onConnectWallet ?? (Signer signer) {}));

  zGoldenTest("When calling `show` it should show the modal", goldenFileName: "connect_modal_show", (tester) async {
    await tester.pumpDeviceBuilder(await goldenDeviceBuilder(Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ConnectModal.show(context, onConnectWallet: (signer) {});
      });

      return const SizedBox();
    })));
  });

  zGoldenTest("When there is wallets installed, it should show the list of wallets",
      goldenFileName: "connect_modal_wallets_list", (tester) async {
    when(() => wallet.installedWallets).thenReturn(
      List.generate(
        10,
        (i) => WalletDetail(
          info: WalletInfo(name: "Wallet $i", icon: "icon", rdns: "rdns"),
          provider: EthereumProviderMock(),
        ),
      ),
    );

    await tester.pumpDeviceBuilder(await goldenBuilder());
  });

  zGoldenTest("When connecting to a specific wallet, it should call the callback with the signer", (tester) async {
    when(() => wallet.installedWallets).thenReturn(
      List.generate(
        10,
        (i) => WalletDetail(
          info: WalletInfo(name: "Wallet $i", icon: "icon", rdns: "rdns"),
          provider: EthereumProviderMock(),
        ),
      ),
    );

    final expectedSigner = SignerMock();
    Signer? actualSigner;

    when(() => wallet.connect(any())).thenAnswer((_) async => expectedSigner);

    await tester.pumpDeviceBuilder(await goldenBuilder(
      onConnectWallet: (signer) => actualSigner = signer,
    ));

    await tester.tap(find.byKey(const Key("wallet-button-1")));
    await tester.pumpAndSettle();

    expect(actualSigner.hashCode, expectedSigner.hashCode);
  });
}
