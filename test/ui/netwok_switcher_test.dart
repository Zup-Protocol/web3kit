import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:golden_toolkit/golden_toolkit.dart";
import "package:mocktail/mocktail.dart";
import "package:web3kit/core/exceptions/ethereum_request_exceptions.dart";
import "package:web3kit/web3kit.dart";

import "../mocks.dart";
import "golden_config.dart";

void main() {
  late Wallet wallet;

  setUp(() {
    wallet = WalletMock();
    mockInjections(customWallet: wallet);

    when(() => wallet.switchNetwork(any())).thenAnswer((_) async {});
  });

  tearDown(() => resetInjections());

  Future<DeviceBuilder> goldenBuilder({
    List<NetworkSwitcherItem>? networks,
    double buttonHeight = 60,
    int initialNetworkIndex = 0,
    bool addNetworksToWallet = true,
    Function(NetworkSwitcherItem item)? onSelect,
  }) async =>
      await goldenDeviceBuilder(
        NetworkSwitcher(
          buttonHeight: buttonHeight,
          initialNetworkIndex: initialNetworkIndex,
          addNetworksToWallet: addNetworksToWallet,
          onSelect: onSelect ?? (item) {},
          networks: networks ??
              [
                NetworkSwitcherItem(
                  title: "Network 1",
                  chainInfo: const ChainInfo(hexChainId: "0x1"),
                ),
                NetworkSwitcherItem(
                  title: "Network 2",
                  chainInfo: const ChainInfo(hexChainId: "0x2"),
                ),
              ],
        ),
      );

  zGoldenTest("Network Switcher Default", goldenFileName: "network_switcher", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder());
  });

  zGoldenTest("Network Switcher Default with icon", goldenFileName: "network_switcher_with_icon", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
        icon: const Icon(Icons.add),
      ),
    ]));
  });

  zGoldenTest("When setting the height param, it should change the height",
      goldenFileName: "network_switcher_custom_height", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(buttonHeight: 100, networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
      ),
    ]));
  });

  zGoldenTest("When clicking the button it should show the whole list of networks -> Without icons",
      goldenFileName: "network_switcher_click", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
      ),
      NetworkSwitcherItem(
        title: "Network 2",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
      ),
      NetworkSwitcherItem(
        title: "Network 3",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
      ),
      NetworkSwitcherItem(
        title: "Network 4",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
      ),
    ]));

    await tester.tap(find.byKey(const Key("network-switcher")));
    await tester.pumpAndSettle();
  });

  zGoldenTest("When clicking the button it should show the whole list of networks -> With icons",
      goldenFileName: "network_switcher_click_with_icon", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
        icon: const Icon(Icons.add),
      ),
      NetworkSwitcherItem(
        title: "Network 2",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
        icon: const Icon(Icons.access_alarm_sharp),
      ),
      NetworkSwitcherItem(
        title: "Network 3",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
        icon: const Icon(Icons.airline_seat_recline_extra),
      ),
      NetworkSwitcherItem(
        title: "Network 4",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
        icon: const Icon(Icons.area_chart_sharp),
      ),
    ]));

    await tester.tap(find.byKey(const Key("network-switcher")));
    await tester.pumpAndSettle();
  });

  zGoldenTest("When passing the initial network index param, it should start with that network selected",
      goldenFileName: "network_switcher_initial_network", (tester) async {
    await tester.pumpDeviceBuilder(await goldenBuilder(initialNetworkIndex: 3, networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
        icon: const Icon(Icons.add),
      ),
      NetworkSwitcherItem(
        title: "Network 2",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
        icon: const Icon(Icons.access_alarm_sharp),
      ),
      NetworkSwitcherItem(
        title: "Network 3",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
        icon: const Icon(Icons.airline_seat_recline_extra),
      ),
      NetworkSwitcherItem(
        title: "Network 4",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
        icon: const Icon(Icons.area_chart_sharp),
      ),
    ]));
  });

  zGoldenTest("The onSelected callback should be called with the selected network once a network is selected",
      (tester) async {
    final expectedSelectedNetwork = NetworkSwitcherItem(
      title: "Network 3",
      chainInfo: const ChainInfo(hexChainId: "0x2"),
      icon: const Icon(Icons.airline_seat_recline_extra),
    );

    NetworkSwitcherItem? actualSelectedNetwork;

    await tester.pumpDeviceBuilder(await goldenBuilder(
        onSelect: (item) {
          actualSelectedNetwork = item;
        },
        initialNetworkIndex: 0,
        networks: [
          NetworkSwitcherItem(
            title: "Network 1",
            chainInfo: const ChainInfo(hexChainId: "0x1"),
            icon: const Icon(Icons.add),
          ),
          NetworkSwitcherItem(
            title: "Network 2",
            chainInfo: const ChainInfo(hexChainId: "0x2"),
            icon: const Icon(Icons.access_alarm_sharp),
          ),
          expectedSelectedNetwork,
          NetworkSwitcherItem(
            title: "Network 4",
            chainInfo: const ChainInfo(hexChainId: "0x2"),
            icon: const Icon(Icons.area_chart_sharp),
          ),
        ]));

    await tester.tap(find.byKey(const Key("network-switcher")));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Network 3"));
    await tester.pumpAndSettle();

    expect(actualSelectedNetwork, expectedSelectedNetwork);
  });

  zGoldenTest("When the current signer is null, it should not ask to switch network on wallet", (tester) async {
    when(() => wallet.signer).thenReturn(null);

    await tester.pumpDeviceBuilder(await goldenBuilder(networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
      ),
      NetworkSwitcherItem(
        title: "Network 2",
        chainInfo: const ChainInfo(hexChainId: "0x2"),
      ),
    ]));

    await tester.tap(find.byKey(const Key("network-switcher")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Network 2"));
    await tester.pumpAndSettle();

    verifyNever(() => wallet.switchNetwork(any()));
  });

  zGoldenTest("When the current signer is not null, it should ask to switch network on wallet", (tester) async {
    when(() => wallet.signer).thenReturn(SignerMock());
    var expectedSelectedNetwork = NetworkSwitcherItem(
      title: "Network 2",
      chainInfo: const ChainInfo(hexChainId: "0x2"),
    );

    await tester.pumpDeviceBuilder(await goldenBuilder(networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
      ),
      expectedSelectedNetwork
    ]));

    await tester.tap(find.byKey(const Key("network-switcher")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Network 2"));
    await tester.pumpAndSettle();

    verify(() => wallet.switchNetwork(expectedSelectedNetwork.chainInfo!.hexChainId)).called(1);
  });

  zGoldenTest("""When an error occurs while switching the network,
      and the error is that the chain is not added yet, and the param
      `addNetworksToWallet` is true, it should ask to add the chain""", (tester) async {
    when(() => wallet.signer).thenReturn(SignerMock());

    when(() => wallet.switchNetwork(any())).thenThrow(UnrecognizedChainId("0x2"));

    var expectedSelectedNetwork = NetworkSwitcherItem(
      title: "Network 2",
      chainInfo: const ChainInfo(
        hexChainId: "0x2",
        chainName: "Any Chain",
        rpcUrls: ["http://localhost:8545"],
      ),
    );

    await tester.pumpDeviceBuilder(await goldenBuilder(addNetworksToWallet: true, networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
      ),
      expectedSelectedNetwork
    ]));

    await tester.tap(find.byKey(const Key("network-switcher")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Network 2"));
    await tester.pumpAndSettle();

    verify(() => wallet.addNetwork(expectedSelectedNetwork.chainInfo!)).called(1);
  });

  zGoldenTest("""When an error occurs while switching the network,
      and the error is that the chain is not added yet, but the param
      `addNetworksToWallet` is false, it should show an error snack bar and not ask to add the chain""",
      goldenFileName: "network_switcher_error", (tester) async {
    when(() => wallet.signer).thenReturn(SignerMock());

    when(() => wallet.switchNetwork(any())).thenThrow(UnrecognizedChainId("0x2"));

    var expectedSelectedNetwork = NetworkSwitcherItem(
      title: "Network 2",
      chainInfo: const ChainInfo(
        hexChainId: "0x2",
        chainName: "Any Chain",
        rpcUrls: ["http://localhost:8545"],
      ),
    );

    await tester.pumpDeviceBuilder(await goldenBuilder(addNetworksToWallet: false, networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
      ),
      expectedSelectedNetwork
    ]));

    await tester.tap(find.byKey(const Key("network-switcher")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Network 2"));
    await tester.pumpAndSettle();

    verifyNever(() => wallet.addNetwork(expectedSelectedNetwork.chainInfo!));
  });

  zGoldenTest("""When an error occurs while switching the network,
      and the error is not that the chain is not added yet, it should show an error snack bar
      and not ask to add the chain""", goldenFileName: "network_switcher_random_error", (tester) async {
    when(() => wallet.signer).thenReturn(SignerMock());

    when(() => wallet.switchNetwork(any())).thenThrow("ANY ERROR");

    var expectedSelectedNetwork = NetworkSwitcherItem(
      title: "Network 2",
      chainInfo: const ChainInfo(
        hexChainId: "0x2",
        chainName: "Any Chain",
        rpcUrls: ["http://localhost:8545"],
      ),
    );

    await tester.pumpDeviceBuilder(await goldenBuilder(addNetworksToWallet: false, networks: [
      NetworkSwitcherItem(
        title: "Network 1",
        chainInfo: const ChainInfo(hexChainId: "0x1"),
      ),
      expectedSelectedNetwork
    ]));

    await tester.tap(find.byKey(const Key("network-switcher")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Network 2"));
    await tester.pumpAndSettle();

    verifyNever(() => wallet.addNetwork(expectedSelectedNetwork.chainInfo!));
  });
}
