import "package:flutter/material.dart";
import "package:web3kit/core/exceptions/ethereum_request_exceptions.dart";
import "package:web3kit/src/gen/assets.gen.dart";
import "package:web3kit/web3kit.dart";
import "package:zup_ui_kit/zup_ui_kit.dart";

/// Item to represent a network in the [NetworkSwitcher]. This item will be shown in the list of networks when clicking the switcher
class NetworkSwitcherItem extends ZupPopupMenuItem {
  NetworkSwitcherItem({
    required super.title,
    required this.chainInfo,
    super.icon,
  });

  /// Network information about the chain to switch to. If null, it's intended that the wallet should not be requested to change to this network
  ///
  /// Null can be useful in cases that the item is not a real network, like showing an "all" network, which is not a real network, so it should
  /// not request to change the network in the wallet. But it do make sense to be in the networks list
  final ChainInfo? chainInfo;
}

/// Display an widget that allow the user to switch his wallet network.
class NetworkSwitcher extends StatefulWidget {
  const NetworkSwitcher({
    super.key,
    required this.networks,
    this.initialNetworkIndex = 0,
    this.onSelect,
    this.buttonHeight = 50,
    this.addNetworksToWallet = true,
  });

  /// The networks to show in the switcher, when tapping to switch
  final List<NetworkSwitcherItem> networks;

  /// The index of the initial network, the one that will be selected once this widget is shown
  final int initialNetworkIndex;

  /// The callback that will be called when the user selects a network.
  ///
  /// Note that this is called whenever the user selects the button, but it's not guaranteed that
  /// the user changed the network in his wallet.
  final Function(NetworkSwitcherItem item)? onSelect;

  /// The height of the button to open the networks menu. Defaults to 50
  final double buttonHeight;

  /// Whether to add networks to the wallet when the user selects a network and the network is not in the wallet yet.
  ///
  /// Remember to add the required information in [ChainInfo] of the Network item to add a new network to any wallet:
  /// - Chain Id
  /// - RPC Url
  /// - Native Currency
  ///
  /// If those are not provided, an error will be thrown.
  final bool addNetworksToWallet;

  @override
  State<NetworkSwitcher> createState() => _NetworkSwitcherState();
}

class _NetworkSwitcherState extends State<NetworkSwitcher> {
  void switchWalletNetwork(ChainInfo networkInfo) async {
    try {
      await Wallet.shared.switchNetwork(networkInfo.hexChainId);
    } catch (e) {
      try {
        if (widget.addNetworksToWallet && e is UnrecognizedChainId) return Wallet.shared.addNetwork(networkInfo);

        rethrow;
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            ZupSnackBar(
              context,
              customIcon: Assets.icons.rectangle2Swap.svg(package: "web3kit"),
              message: Web3KitLocalizations.of(context).networkSwitcherErrorDescription,
              maxWidth: 630,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZupPopupMenuButton(
      key: const Key("network-switcher"),
      initialSelectedIndex: widget.initialNetworkIndex,
      items: widget.networks,
      buttonHeight: widget.buttonHeight,
      onSelected: (selectedIndex) {
        final selectedNetwork = widget.networks[selectedIndex];
        if (selectedNetwork.chainInfo != null && Wallet.shared.signer != null) {
          switchWalletNetwork(selectedNetwork.chainInfo!);
        }

        widget.onSelect?.call(selectedNetwork);
      },
    );
  }
}
