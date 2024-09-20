import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:random_avatar/random_avatar.dart";
import "package:web3kit/src/cubits/connected_wallet_button/connected_wallet_button_cubit.dart";
import "package:web3kit/web3kit.dart";
import "package:zup_ui_kit/zup_ui_kit.dart";

/// Build a widget that shows the user's connected Wallet
class ConnectedWalletButton extends StatefulWidget {
  const ConnectedWalletButton({super.key, required this.signer, this.width});

  /// The current connected signer
  final Signer signer;

  /// The width of the button. If not passed it will use the minimum width to accommodate the button content
  final double? width;

  @override
  State<ConnectedWalletButton> createState() => _ConnectedWalletButtonState();
}

class _ConnectedWalletButtonState extends State<ConnectedWalletButton> {
  ConnectedWalletButtonCubit? cubit;
  StreamSubscription<Signer?>? _signerStream;

  @override
  void initState() {
    _signerStream = Wallet.shared.signerStream.listen((signer) {
      if (!mounted) return;
      if (signer == null || signer == widget.signer) return;

      cubit?.loadSigner(signer);
    });
    super.initState();
  }

  @override
  void dispose() {
    _signerStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConnectedWalletButtonCubit(widget.signer),
      child: BlocBuilder<ConnectedWalletButtonCubit, ConnectedWalletButtonState>(
        builder: (context, state) {
          cubit = context.read<ConnectedWalletButtonCubit>();

          return SizedBox(
            width: widget.width,
            child: MaterialButton(
              key: const Key("connected-wallet-button"),
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
                error: () => buttonContent(title: Web3KitLocalizations.of(context).unknownAddress),
                success: (address, ensName) => buttonContent(
                  title: ensName ?? address.shortAddress(prefixAndSuffixLength: 4),
                  avatarSeed: address,
                ),
              ),
              onPressed: () => AccountModal.show(context),
            ),
          );
        },
      ),
    );
  }

  Widget buttonContent({String title = "", bool isLoading = false, String avatarSeed = "123"}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
