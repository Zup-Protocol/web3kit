import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3kit/core/core.dart';

part 'wallet_button_cubit.freezed.dart';
part 'wallet_button_state.dart';

class WalletButtonCubit extends Cubit<WalletButtonState> {
  WalletButtonCubit(this.wallet) : super(const WalletButtonState.initial());

  final Wallet wallet;

  void connectWallet(WalletBrand walletProvider) async {
    emit(const WalletButtonState.loading());

    if (!wallet.isWalletInstalled(walletProvider)) emit(const WalletButtonState.notInstalled());

    try {
      await wallet.connect(walletProvider);

      emit(const WalletButtonState.initial());
    } catch (e) {
      if (e is UserRejectedAction) {
        // do nothing
        return emit(const WalletButtonState.initial());
      } else {
        emit(const WalletButtonState.error());
      }
    }
  }
}
