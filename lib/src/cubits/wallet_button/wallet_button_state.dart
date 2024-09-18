part of "wallet_button_cubit.dart";

@internal
@freezed
class WalletButtonState with _$WalletButtonState {
  const factory WalletButtonState.initial() = _Initial;
  const factory WalletButtonState.connectSuccess(Signer signer) = _ConnectSuccess;
  const factory WalletButtonState.loading() = _Loading;
  const factory WalletButtonState.notInstalled() = _NotInstalled;
  const factory WalletButtonState.error() = _Error;
}
