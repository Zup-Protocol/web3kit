import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:web3kit/core/extensions/string_extension.dart';
import 'package:web3kit/gen/assets.gen.dart';
import 'package:web3kit/l10n/gen/app_localizations.dart';
import 'package:web3kit/web3client.dart';
import 'package:zup_ui_kit/zup_ui_kit.dart';

/// Show a modal that contain's the user's connected wallet information
/// call `AccountModal.show()` to open the modal from anywhere
class AccountModal extends StatelessWidget {
  const AccountModal({super.key, required this.walletAddress});

  final String walletAddress;

  static Future<void> show(
    BuildContext context, {
    required String walletAddress,
  }) async {
    ZupModal.show(
      context,
      title: Web3KitLocalizations.of(context).connected,
      size: const Size(300, 350),
      padding: const EdgeInsets.all(20).copyWith(top: 0),
      content: AccountModal(walletAddress: walletAddress),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(width: 5, strokeAlign: 0.1, color: Colors.brown),
              borderRadius: BorderRadius.circular(50)),
          child: RandomAvatar(walletAddress, height: 100, width: 100),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZupPrimaryButton(
              hoverElevation: 0,
              backgroundColor: ZupColors.white,
              foregroundColor: ZupColors.black,
              border: const BorderSide(color: ZupColors.gray5, width: 1),
              title: walletAddress.shortAddress(prefixAndSuffixLength: 6),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: walletAddress));
                ScaffoldMessenger.of(context).showSnackBar(
                  ZupSnackBar(
                    context,
                    message: Web3KitLocalizations.of(context).addressCopiedText,
                    type: ZupSnackBarType.info,
                    showCloseIcon: false,
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
          hoverElevation: 0,
          backgroundColor: ZupColors.red5,
          foregroundColor: ZupColors.red,
          title: Web3KitLocalizations.of(context).disconnectWallet,
          fixedIcon: false,
          icon: Assets.icons.cableConnectorSlash.svg(package: "web3kit"),
          onPressed: () async {
            Navigator.of(context).pop();
            await Web3client.shared.wallet.disconnect();
          },
        )
      ],
    );
  }
}
