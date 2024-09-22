import "package:flutter/material.dart";
import "package:web3kit/core/dtos/network_info.dart";
import "package:web3kit/core/wallet.dart";
import "package:zup_ui_kit/buttons/zup_popup_button.dart";

/// Item to represent a network in the [NetworkSwitcher]. This item will be shown in the list of networks when clicking the switcher
class NetworkSwitcherItem extends ZupPopupMenuItem {
  NetworkSwitcherItem({
    required super.title,
    required this.networkInfo,
    super.icon,
  });

  /// Network information about the chain to switch to. If null, it's intended that the wallet should not be requested to change to this network
  ///
  /// Null can be useful in cases that the item is not a real network, like showing an "all" network, which is not a real network, so it should
  /// not request to change the network in the wallet. But it do make sense to be in the networks list
  final NetworkInfo? networkInfo;
}

/// Display an widget that allow the user to switch his wallet network.
class NetworkSwitcher extends StatefulWidget {
  const NetworkSwitcher({super.key, required this.networks, this.initialNetworkIndex = 0, this.onSelect});

  /// The networks to show in the switcher, when tapping to switch
  final List<NetworkSwitcherItem> networks;

  /// The index of the initial network, the one that will be selected once this widget is shown
  final int initialNetworkIndex;

  /// The callback that will be called when the user selects a network
  final Function(NetworkSwitcherItem item)? onSelect;

  @override
  State<NetworkSwitcher> createState() => _NetworkSwitcherState();
}

class _NetworkSwitcherState extends State<NetworkSwitcher> {
  void switchNetwork(NetworkInfo networkInfo) {
    Wallet.shared.switchNetwork(networkInfo.hexChainId);
  }

  @override
  Widget build(BuildContext context) {
    return ZupPopupMenuButton(
      initialSelectedIndex: 0,
      items: widget.networks,
      onSelected: (selectedIndex) {
        final selectedNetwork = widget.networks[selectedIndex];
        if (selectedNetwork.networkInfo != null && Wallet.shared.signer != null) {
          switchNetwork(selectedNetwork.networkInfo!);
        }

        widget.onSelect?.call(selectedNetwork);
      },
    );
  }
}
