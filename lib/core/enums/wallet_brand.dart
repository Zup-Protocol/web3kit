import 'package:flutter/material.dart';
import 'package:web3kit/gen/assets.gen.dart';

/// List of wallets supported by web3kit
enum WalletBrand {
  metamask,
  rabby,
  onekey,
  rainbow,
  phantom,
  trustWallet,
  coinbaseWallet,
}

extension WalletExtension on WalletBrand {
  String get label => [
        "Metamask",
        "Rabby Wallet",
        "OneKey",
        "Rainbow",
        "Phantom",
        "Trust Wallet",
        "Coinbase Wallet",
      ][index];

  Color get mainColor => [
        const Color(0xFFF6851B),
        const Color(0xFF8697FF),
        const Color(0xFF191919),
        const Color(0xFF143C8F),
        const Color(0xFF5448B7),
        const Color(0xFF3375BB),
        const Color(0xFF0052FF),
      ][index];

  Widget get icon => [
        Assets.icons.metamask.svg(package: "web3kit"),
        Assets.icons.rabby.svg(package: "web3kit"),
        Assets.icons.onekey.svg(package: "web3kit"),
        Assets.icons.rainbow.svg(package: "web3kit"),
        Assets.icons.phantom.svg(package: "web3kit"),
        Assets.icons.trustWallet.svg(package: "web3kit"),
        Assets.icons.coinbaseWallet.svg(package: "web3kit"),
      ][index];

  String get provider => [
        "ethereum",
        "rabby",
        r"$onekey",
        "rainbow",
        "phantom",
        "trustWallet",
        "coinbaseWallet",
      ][index];
}
