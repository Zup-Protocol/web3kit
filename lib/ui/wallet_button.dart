import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web3kit/core/core.dart';
import 'package:web3kit/core/dtos/wallet_detail.dart';
import 'package:web3kit/cubits/wallet_button/wallet_button_cubit.dart';
import 'package:web3kit/gen/assets.gen.dart';
import 'package:web3kit/web3kit.dart';
import 'package:zup_ui_kit/zup_ui_kit.dart';

/// Show a button widget that allows the user to connect their wallet once they click it
class WalletButton extends StatefulWidget {
  const WalletButton({super.key, required this.wallet, required this.onConnect});

  final WalletDetail wallet;
  final Function(Signer signer) onConnect;

  @override
  State<WalletButton> createState() => _WalletButtonState();
}

class _WalletButtonState extends State<WalletButton> with TickerProviderStateMixin {
  bool isHovering = false;

  final wallet = Web3client.shared.wallet;
  AnimationController? animationController;

  bool isIconSVG(String iconURI) => iconURI.trim().toLowerCase().startsWith("data:image/svg");

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
          connectSuccess: (signer) {
            animationController?.reset();
            return widget.onConnect(signer);
          },
          error: () {
            animationController?.reset();

            return ScaffoldMessenger.of(context).showSnackBar(ZupSnackBar(
              message: Web3KitLocalizations.of(context).walletButtonConnectError(widget.wallet.info.name),
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
                color: isHovering ? Theme.of(context).primaryColor : ZupColors.gray5,
                width: isHovering ? 1.5 : 0.5,
              ),
            ),
            child: MouseRegion(
              onEnter: (event) => setState(() => isHovering = true),
              onExit: (event) => setState(() => isHovering = false),
              child: MaterialButton(
                elevation: 0,
                hoverElevation: 0,
                hoverColor: Theme.of(context).primaryColor.withOpacity(0.1),
                animationDuration: const Duration(milliseconds: 500),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(20).copyWith(right: 18),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: isIconSVG(widget.wallet.info.icon)
                              ? SvgPicture.network(widget.wallet.info.icon.trim())
                              : Image.network(widget.wallet.info.icon.trim()),
                        ),
                      ),
                    ).animate(
                      effects: [const ShimmerEffect(duration: Duration(milliseconds: 600)), const ShakeEffect(hz: 5)],
                      controller: animationController,
                      autoPlay: false,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.wallet.info.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isHovering ? Theme.of(context).primaryColor : ZupColors.black,
                      ),
                    ),
                    const Spacer(),
                    if (Web3client.shared.wallet.installedWallets.contains(widget.wallet))
                      Text(
                        Web3KitLocalizations.of(context).installed,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: ZupColors.gray),
                      )
                  ],
                ),
                onPressed: () async => cubit.connectWallet(widget.wallet),
              ),
            ),
          );
        },
      ),
    );
  }
}
