import "package:flutter/material.dart";
import "package:web3kit/src/gen/assets.gen.dart";
import "package:web3kit/web3kit.dart";
import "package:zup_ui_kit/buttons/buttons.dart";

/// Build a button widget that allows the user to connect their wallet
/// and update the UI accordingly
class ConnectButton extends StatefulWidget {
  const ConnectButton({super.key, this.backgroundColor, this.foregroundColor, this.customIcon});

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? customIcon;

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Wallet.shared.signer,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? ZupPrimaryButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  title: "Connect Wallet",
                  onPressed: () => ConnectModal.show(context, onConnectWallet: (signer) {}),
                  icon: Assets.icons.cableConnectorHorizontal.svg(package: "web3kit"),
                )
              : ConnectedWalletButton(signer: snapshot.data!);
        });
  }
}
