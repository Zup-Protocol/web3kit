import "package:flutter/material.dart";
import "package:web3kit/src/gen/assets.gen.dart";
import "package:web3kit/web3kit.dart";
import "package:zup_ui_kit/zup_ui_kit.dart";

/// Build a button widget that allows the user to connect their wallet
/// and update the UI accordingly
class ConnectButton extends StatelessWidget {
  const ConnectButton({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.customIcon,
    this.onConnectWallet,
    this.compact = false,
    this.height,
  });

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

  /// Set a custom height for the button
  final double? height;

  /// Whether the button should be compact or not.
  /// If true, the button will be a small icon button only. Default is false.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Wallet.shared.signerStream,
      initialData: Wallet.shared.signer,
      builder: (context, snapshot) {
        return snapshot.data == null
            ? buildConnectButton(context)
            : ConnectedWalletButton(signer: snapshot.data!, compact: compact);
      },
    );
  }

  Widget buildConnectButton(BuildContext context) {
    Future<void> onPressed() => ConnectModal(onConnectWallet: (signer) => onConnectWallet?.call(signer)).show(context);

    if (compact) {
      return ZupIconButton(
        minimumHeight: height,
        icon: Assets.icons.cableConnectorHorizontal.svg(package: "web3kit", height: 6, width: 6),
        iconColor: ZupColors.white,
        backgroundColor: ZupColors.brand,
        padding: const EdgeInsets.all(20),
        onPressed: (_) => onPressed(),
      );
    }
    return ZupPrimaryButton(
      height: height ?? 50,
      key: const Key("connect-button"),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      title: Web3KitLocalizations.of(context).connectWallet,
      onPressed: (buttonContext) => onPressed(),
      icon: customIcon ?? Assets.icons.cableConnectorHorizontal.svg(package: "web3kit"),
    );
  }
}
