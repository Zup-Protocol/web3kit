import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/core/exceptions/ethers_exceptions.dart";

part "wallet_button_cubit.freezed.dart";
part "wallet_button_state.dart";

@internal
class WalletButtonCubit extends Cubit<WalletButtonState> {
  WalletButtonCubit(this.wallet) : super(const WalletButtonState.initial());

  final Wallet wallet;

  void connectWallet(WalletDetail walletDetail) async {
    emit(const WalletButtonState.loading());

    try {
      Signer signer = await wallet.connect(walletDetail);

      emit(WalletButtonState.connectSuccess(signer));
    } catch (e) {
      if (e is UserRejectedAction) {
        return emit(const WalletButtonState.initial());
      } else {
        emit(const WalletButtonState.error());
      }
    }
  }
}
