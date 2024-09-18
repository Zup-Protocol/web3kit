import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:random_avatar/random_avatar.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/src/cubits/connected_wallet_button/connected_wallet_button_cubit.dart";
import "package:web3kit/ui/account_modal.dart";
import "package:zup_ui_kit/zup_ui_kit.dart";

/// Build a widget that shows the user's connected Wallet
class ConnectedWalletButton extends StatefulWidget {
  const ConnectedWalletButton({super.key, required this.signer});

  final Signer signer;

  @override
  State<ConnectedWalletButton> createState() => _ConnectedWalletButtonState();
}

class _ConnectedWalletButtonState extends State<ConnectedWalletButton> {
  ConnectedWalletButtonCubit? cubit;

  @override
  void initState() {
    Web3Client.shared.wallet.signer.listen((signer) {
      if (signer != null && signer != widget.signer) {
        if (mounted) cubit?.loadSigner(signer);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConnectedWalletButtonCubit(widget.signer),
      child: BlocBuilder<ConnectedWalletButtonCubit, ConnectedWalletButtonState>(
        builder: (context, state) {
          cubit = context.read<ConnectedWalletButtonCubit>();

          return MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: ZupColors.gray5),
            ),
            color: ZupColors.white,
            hoverElevation: 14,
            animationDuration: const Duration(milliseconds: 700),
            elevation: 0,
            height: 50,
            padding: const EdgeInsets.all(20),
            child: state.maybeWhen(
              orElse: () => buttonContent(isLoading: true),
              success: (address, ensName) => buttonContent(
                title: ensName ?? address.shortAddress(prefixAndSuffixLength: 4),
                avatarSeed: address,
              ),
            ),
            onPressed: () => AccountModal.show(
              context,
              walletAddress: cubit?.signerAddress ?? "",
            ),
          );
        },
      ),
    );
  }

  Widget buttonContent({String title = "", bool isLoading = false, String avatarSeed = ""}) {
    return Row(
      children: [
        SizedBox(
            height: 26,
            width: 26,
            child: isLoading ? const CircleAvatar(backgroundColor: ZupColors.gray5) : RandomAvatar(avatarSeed)),
        const SizedBox(width: 10),
        isLoading
            ? Container(
                height: 14,
                width: 80,
                decoration: BoxDecoration(color: ZupColors.gray5, borderRadius: BorderRadius.circular(12)),
              )
            : Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
      ],
    );
  }
}
