import 'package:flutter/material.dart';
import 'package:web3kit/core/core.dart';
import 'package:zup_ui_kit/zup_colors.dart';

class WalletButton extends StatefulWidget {
  const WalletButton({super.key, required this.wallet});

  final WalletBrand wallet;

  @override
  State<WalletButton> createState() => _WalletButtonState();
}

class _WalletButtonState extends State<WalletButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHovering ? widget.wallet.mainColor : ZupColors.gray5,
          width: isHovering ? 1.5 : 0.5,
        ),
      ),
      child: MouseRegion(
        onEnter: (event) => setState(() => isHovering = true),
        onExit: (event) => setState(() => isHovering = false),
        child: MaterialButton(
          color: isHovering ? widget.wallet.mainColor.withOpacity(.1) : Colors.transparent,
          splashColor: widget.wallet.mainColor.withOpacity(0.1),
          elevation: 0,
          hoverElevation: 0,
          animationDuration: const Duration(milliseconds: 500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(12).copyWith(right: 20),
          child: Row(
            children: [
              SizedBox(width: 50, height: 50, child: widget.wallet.icon),
              const SizedBox(width: 16),
              Text(
                widget.wallet.label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (Wallet.shared.isWalletInstalled(widget.wallet))
                const Text(
                  "Installed",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: ZupColors.gray),
                )
            ],
          ),
          onPressed: () async => await Wallet.shared.connect(widget.wallet),
        ),
      ),
    );
  }
}
