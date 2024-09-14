import 'package:flutter/material.dart';
import 'package:web3kit/core/enums/wallet_brand.dart';
import 'package:web3kit/ui/wallet_button.dart';
import 'package:zup_ui_kit/modals/zup_modal.dart';

/// Show a modal that allows the user to connect their wallet.
///
/// call `ConnectModal.show()` to open the modal from anywhere
class ConnectModal extends StatelessWidget {
  const ConnectModal({super.key});

  static Future<void> show(BuildContext context) async {
    ZupModal.show(
      context,
      title: "Select your Wallet",
      description: "Choose how you want to connect to use the protocol!",
      size: const Size(400, 500),
      content: const ConnectModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: const ScrollbarThemeData(mainAxisMargin: 10, crossAxisMargin: 5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20).copyWith(top: 0),
        child: Column(
          children: List.generate(
            WalletBrand.values.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: WalletButton(
                walletProvider: WalletBrand.values[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
