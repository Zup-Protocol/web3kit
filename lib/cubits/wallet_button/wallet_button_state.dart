part of 'wallet_button_cubit.dart';

@freezed
class WalletButtonState with _$WalletButtonState {
  const factory WalletButtonState.initial() = _Initial;
  const factory WalletButtonState.loading() = _Loading;
  const factory WalletButtonState.notInstalled() = _NotInstalled;
  const factory WalletButtonState.error() = _Error;
}
