// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class Web3KitLocalizationsEn extends Web3KitLocalizations {
  Web3KitLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get connectModalNoWalletsFound => 'No Wallets Found...';

  @override
  String get connectModalNoWalletsFoundDescription =>
      'It looks like you don’t have a wallet installed. Please install one to proceed';

  @override
  String get whatIsAWallet => 'What\'s a wallet?';

  @override
  String get installed => 'Installed';

  @override
  String get unknownAddress => 'Unknown Address';

  @override
  String get connectWallet => 'Connect Wallet';

  @override
  String get connected => 'Connected';

  @override
  String get disconnectWallet => 'Disconnect Wallet';

  @override
  String get addressCopiedText => 'Address copied to clipboard';

  @override
  String get connectModalDescription =>
      'Choose how you want to connect to use the protocol!';

  @override
  String get networkSwitcherErrorDescription =>
      'Unable to switch the network in your wallet. Please switch the network manually!';

  @override
  String walletButtonConnectError(String wallet) {
    return 'An error occurred while attempting to connect to $wallet!';
  }

  @override
  String walletButtonWalletNotInstalled(String wallet) {
    return '$wallet is not installed!';
  }
}
