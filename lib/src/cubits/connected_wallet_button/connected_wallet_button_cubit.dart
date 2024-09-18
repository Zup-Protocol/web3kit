import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/core/core.dart";

part "connected_wallet_button_cubit.freezed.dart";
part "connected_wallet_button_state.dart";

@internal
class ConnectedWalletButtonCubit extends Cubit<ConnectedWalletButtonState> {
  ConnectedWalletButtonCubit(Signer signer) : super(const ConnectedWalletButtonState.loading()) {
    loadSigner(signer);
  }

  String signerAddress = "";
  String? signerENS;

  void loadSigner(Signer signer) async {
    emit(const ConnectedWalletButtonState.loading());

    try {
      signerAddress = await signer.address;
      signerENS = await signer.ensName;

      emit(ConnectedWalletButtonState.success(signerAddress, signerENS));
    } catch (e) {
      emit(const ConnectedWalletButtonState.error());
    }
  }
}
