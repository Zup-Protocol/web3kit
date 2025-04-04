import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:random_avatar/random_avatar.dart";
import "package:web3kit/src/cubits/connected_wallet_button/connected_wallet_button_cubit.dart";
import "package:web3kit/web3kit.dart";
import "package:zup_core/zup_core.dart";
import "package:zup_ui_kit/zup_ui_kit.dart";

/// Build a widget that shows the user's connected Wallet
class ConnectedWalletButton extends StatefulWidget {
  const ConnectedWalletButton({super.key, required this.signer, this.width, this.height = 50, this.compact = false});

  /// The current connected signer
  final Signer signer;

  /// The width of the button. If not passed it will use the minimum width to accommodate the button content
  final double? width;

  /// The max height of the button
  final double height;

  /// Whether the button should be compact or not
  final bool compact;

  @override
  State<ConnectedWalletButton> createState() => _ConnectedWalletButtonState();
}

class _ConnectedWalletButtonState extends State<ConnectedWalletButton> with DeviceInfoMixin {
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
            height: widget.height,
            child: MaterialButton(
              minWidth: widget.compact ? 0 : null,
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: state.maybeWhen(
                orElse: () => buttonContent(isLoading: true),
                error: () => buttonContent(title: Web3KitLocalizations.of(context).unknownAddress),
                success: (address, ensName) => buttonContent(
                  title: ensName ?? address.shortAddress(prefixAndSuffixLength: isMobileSize(context) ? 2 : 4),
                  avatarSeed: address,
                ),
              ),
              onPressed: () => const AccountModal().show(context),
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
        if (!widget.compact) ...[
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
        ]
      ],
    );
  }
}
