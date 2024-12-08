import "package:flutter/material.dart";
import "package:web3kit/src/gen/assets.gen.dart";
import "package:web3kit/web3kit.dart";
import "package:zup_ui_kit/buttons/buttons.dart";

/// Build a button widget that allows the user to connect their wallet
/// and update the UI accordingly
class ConnectButton extends StatelessWidget {
  const ConnectButton({super.key, this.backgroundColor, this.foregroundColor, this.customIcon, this.onConnectWallet});

  /// change the background color of the button
  final Color? backgroundColor;

  /// change the foreground color of the button, text and icon
  final Color? foregroundColor;

  /// add a custom icon to show on the button
  final Widget? customIcon;

  /// callback called when the user connect his wallet using the button flow. (it's not called when the user connect with other means)
  ///
  /// If you want to listen to whenever the user connect his wallet, use `Wallet.shared.signerStream`
  final Function(Signer)? onConnectWallet;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Wallet.shared.signerStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? ZupPrimaryButton(
                  key: const Key("connect-button"),
                  backgroundColor: backgroundColor,
                  foregroundColor: foregroundColor,
                  title: Web3KitLocalizations.of(context).connectWallet,
                  onPressed: () => ConnectModal(onConnectWallet: (signer) => onConnectWallet?.call(signer)).show(
                    context,
                  ),
                  icon: customIcon ?? Assets.icons.cableConnectorHorizontal.svg(package: "web3kit"),
                )
              : ConnectedWalletButton(signer: snapshot.data!);
        });
  }
}
