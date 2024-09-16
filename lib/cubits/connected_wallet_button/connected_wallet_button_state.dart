part of 'connected_wallet_button_cubit.dart';

@freezed
class ConnectedWalletButtonState with _$ConnectedWalletButtonState {
  const factory ConnectedWalletButtonState.loading() = _Loading;
  const factory ConnectedWalletButtonState.success(String address, String? ensName) = _Success;
  const factory ConnectedWalletButtonState.error() = _Error;
}
