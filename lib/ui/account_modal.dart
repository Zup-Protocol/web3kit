import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:random_avatar/random_avatar.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/gen/assets.gen.dart";
import "package:web3kit/src/l10n/gen/app_localizations.dart";
import "package:zup_core/mixins/device_info_mixin.dart";
import "package:zup_ui_kit/zup_ui_kit.dart";

/// Show a modal that contain's the user's connected wallet information.
/// Call `AccountModal().show()` to open the modal from anywhere
///
/// `![Warning]` the modal will not open if the application is not connected to a wallet
class AccountModal extends StatelessWidget with DeviceInfoMixin {
  const AccountModal({super.key});

  Future<void> show(BuildContext context) async {
    ZupModal.show(
      context,
      showAsBottomSheet: isMobileSize(context),
      title: Web3KitLocalizations.of(context).connected,
      size: const Size(300, 350),
      padding: const EdgeInsets.all(20).copyWith(top: 0),
      content: const AccountModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Signer?>(
        stream: Wallet.shared.signerStream,
        initialData: Wallet.shared.signer,
        builder: (context, signerSnapshot) {
          if (!signerSnapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
            return const SizedBox.shrink();
          }

          return FutureBuilder<String>(
              future: signerSnapshot.data?.address,
              initialData: ".............",
              builder: (context, addressSnapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(width: 5, strokeAlign: 0.1, color: Colors.brown),
                          borderRadius: BorderRadius.circular(50)),
                      child: RandomAvatar(addressSnapshot.data ?? "", height: 100, width: 100),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ZupPrimaryButton(
                          key: const Key("copy-address"),
                          hoverElevation: 0,
                          backgroundColor: ZupColors.white,
                          foregroundColor: ZupColors.black,
                          border: const BorderSide(color: ZupColors.gray5, width: 1),
                          title: addressSnapshot.data?.shortAddress(prefixAndSuffixLength: 6) ?? "",
                          onPressed: (buttonContext) {
                            Clipboard.setData(ClipboardData(text: addressSnapshot.data ?? ""));
                            ScaffoldMessenger.of(context).showSnackBar(
                              ZupSnackBar(
                                context,
                                message: Web3KitLocalizations.of(context).addressCopiedText,
                                type: ZupSnackBarType.info,
                                hideCloseIcon: true,
                                snackDuration: const Duration(milliseconds: 2000),
                              ),
                            );
                          },
                          icon: Assets.icons.squareOnSquare.svg(package: "web3kit"),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ZupPrimaryButton(
                      key: const Key("disconnect-wallet"),
                      hoverElevation: 0,
                      backgroundColor: ZupColors.red5,
                      foregroundColor: ZupColors.red,
                      title: Web3KitLocalizations.of(context).disconnectWallet,
                      fixedIcon: false,
                      mainAxisSize: MainAxisSize.max,
                      icon: Assets.icons.cableConnectorSlash.svg(package: "web3kit"),
                      onPressed: (buttonContext) async => await Wallet.shared.disconnect(),
                    )
                  ],
                );
              });
        });
  }
}
