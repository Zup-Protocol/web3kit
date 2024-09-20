import "package:flutter/material.dart";
import "package:web3kit/web3kit.dart";
import "package:zup_ui_kit/modals/zup_modal.dart";

/// Show a modal that allows the user to connect their wallet.
///
/// call `ConnectModal.show()` to open the modal from anywhere
class ConnectModal extends StatelessWidget {
  const ConnectModal({super.key, required this.onConnectWallet});

  final Function(Signer signer)? onConnectWallet;

  static Future<void> show(
    BuildContext context, {
    required Function(Signer signer)? onConnectWallet,
  }) async {
    ZupModal.show(
      context,
      title: Web3KitLocalizations.of(context).connectWallet,
      description: Web3KitLocalizations.of(context).connectModalDescription,
      size: const Size(400, 500),
      content: ConnectModal(onConnectWallet: onConnectWallet),
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
            Wallet.shared.installedWallets.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: WalletButton(
                key: Key("wallet-button-$index"),
                onConnect: (signer) {
                  if (onConnectWallet != null) onConnectWallet!(signer);

                  Navigator.of(context).pop();
                },
                walletDetail: Wallet.shared.installedWallets[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
