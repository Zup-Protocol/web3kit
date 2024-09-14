import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3kit/core/core.dart';
import 'package:web3kit/cubits/wallet_button/wallet_button_cubit.dart';
import 'package:web3kit/gen/assets.gen.dart';
import 'package:web3kit/web3kit.dart';
import 'package:zup_ui_kit/zup_ui_kit.dart';

class WalletButton extends StatefulWidget {
  const WalletButton({super.key, required this.walletProvider});

  final WalletBrand walletProvider;

  @override
  State<WalletButton> createState() => _WalletButtonState();
}

class _WalletButtonState extends State<WalletButton> with TickerProviderStateMixin {
  bool isHovering = false;

  final wallet = Web3client.shared.wallet;
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletButtonCubit(wallet),
      child: BlocConsumer<WalletButtonCubit, WalletButtonState>(
        listener: (context, state) => state.maybeWhen(
          loading: () => animationController?.loop(),
          notInstalled: () {
            animationController?.reset();

            return ScaffoldMessenger.of(context).showSnackBar(ZupSnackBar(
              message: "${widget.walletProvider.label} is not Installed!",
              customIcon: Assets.icons.walletBifold.svg(package: "web3kit"),
              context,
              type: ZupSnackBarType.error,
            ));
          },
          orElse: () => animationController?.reset(),
        ),
        builder: (context, state) {
          final cubit = context.read<WalletButtonCubit>();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHovering ? widget.walletProvider.mainColor : ZupColors.gray5,
                width: isHovering ? 1.5 : 0.5,
              ),
            ),
            child: MouseRegion(
              onEnter: (event) => setState(() => isHovering = true),
              onExit: (event) => setState(() => isHovering = false),
              child: MaterialButton(
                color: isHovering ? widget.walletProvider.mainColor.withOpacity(.1) : Colors.transparent,
                splashColor: widget.walletProvider.mainColor.withOpacity(0.1),
                elevation: 0,
                hoverElevation: 0,
                animationDuration: const Duration(milliseconds: 500),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(12).copyWith(right: 20),
                child: Row(
                  children: [
                    SizedBox(width: 50, height: 50, child: widget.walletProvider.icon).animate(
                      effects: [const ShimmerEffect(duration: Duration(milliseconds: 600)), const ShakeEffect(hz: 5)],
                      controller: animationController,
                      autoPlay: false,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.walletProvider.label,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    if (Web3client.shared.wallet.isWalletInstalled(widget.walletProvider))
                      const Text(
                        "Installed",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: ZupColors.gray),
                      )
                  ],
                ),
                onPressed: () async => cubit.connectWallet(widget.walletProvider),
              ),
            ),
          );
        },
      ),
    );
  }
}
