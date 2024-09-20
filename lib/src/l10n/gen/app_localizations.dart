import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of Web3KitLocalizations
/// returned by `Web3KitLocalizations.of(context)`.
///
/// Applications need to include `Web3KitLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Web3KitLocalizations.localizationsDelegates,
///   supportedLocales: Web3KitLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Web3KitLocalizations.supportedLocales
/// property.
abstract class Web3KitLocalizations {
  Web3KitLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Web3KitLocalizations of(BuildContext context) {
    return Localizations.of<Web3KitLocalizations>(
        context, Web3KitLocalizations)!;
  }

  static const LocalizationsDelegate<Web3KitLocalizations> delegate =
      _Web3KitLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @installed.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// No description provided for @unknownAddress.
  ///
  /// In en, this message translates to:
  /// **'Unknown Address'**
  String get unknownAddress;

  /// No description provided for @connectWallet.
  ///
  /// In en, this message translates to:
  /// **'Connect Wallet'**
  String get connectWallet;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnectWallet.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Wallet'**
  String get disconnectWallet;

  /// No description provided for @addressCopiedText.
  ///
  /// In en, this message translates to:
  /// **'Address copied to clipboard'**
  String get addressCopiedText;

  /// No description provided for @connectModalDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to connect to use the protocol!'**
  String get connectModalDescription;

  /// No description provided for @walletButtonConnectError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while attempting to connect to {wallet}!'**
  String walletButtonConnectError(String wallet);

  /// No description provided for @walletButtonWalletNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'{wallet} is not installed!'**
  String walletButtonWalletNotInstalled(String wallet);
}

class _Web3KitLocalizationsDelegate
    extends LocalizationsDelegate<Web3KitLocalizations> {
  const _Web3KitLocalizationsDelegate();

  @override
  Future<Web3KitLocalizations> load(Locale locale) {
    return SynchronousFuture<Web3KitLocalizations>(
        lookupWeb3KitLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_Web3KitLocalizationsDelegate old) => false;
}

Web3KitLocalizations lookupWeb3KitLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return Web3KitLocalizationsEn();
  }

  throw FlutterError(
      'Web3KitLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
