// coverage:ignore-file
// ignore_for_file: implementation_imports

import "package:web3kit/core/exceptions/ethers_exceptions.dart";
import "package:web3kit/core/ethereum_calldata_encoder.dart";
import "package:web3kit/core/signer.dart";
import "package:web3kit/src/extensions/bigint_extension.dart";
import "package:web3kit/core/dtos/transaction_response.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart"
    if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/package_mocks/js_interop_unsafe_mock.dart"
    if (dart.library.html) "dart:js_interop_unsafe";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethereum_provider.js.dart";
import "package:web3kit/src/mocks/ethers_signer.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_signer.js.dart";
import "package:web3kit/src/mocks/utils.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/utils.js.dart";
import "package:web3kit/src/mocks/ethers_contract_transaction_response.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_contract_transaction_response.js.dart";
import "package:web3kit/src/mocks/ethers_json_rpc_provider.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_json_rpc_provider.js.dart";

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  Web3Kit
/// *****************************************************

class Erc20 {
  static String abi = """[
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "account",
                "type": "address"
            }
        ],
        "name": "balanceOf",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "decimals",
        "outputs": [
            {
                "internalType": "uint8",
                "name": "",
                "type": "uint8"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "name": "from",
                "type": "address"
            },
            {
                "indexed": true,
                "name": "to",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "value",
                "type": "uint256"
            }
        ],
        "name": "Transfer",
        "type": "event"
    }
]""";

  /// Create a new instance of [Erc20] using the given RPC provider to make contract calls
  Erc20Impl fromRpcProvider({
    required String contractAddress,
    required String rpcUrl,
  }) {
    return Erc20Impl._(JSEthersContract(
      contractAddress.toJS,
      abi.toJS,
      JSEthersJsonRpcProvider(rpcUrl.toJS),
    ));
  }

  /// Create a new instance of [Erc20] using a connected signer to make contract calls
  Erc20Impl fromSigner({
    required String contractAddress,
    required Signer signer,
  }) {
    return Erc20Impl._(JSEthersContract.fromSigner(
      contractAddress.toJS,
      abi.toJS,
      signer.ethersSigner,
    ));
  }
}

class Erc20Impl {
  Erc20Impl._(JSEthersContract this._jsEthersContract);

  final JSEthersContract _jsEthersContract;

  Future<BigInt> balanceOf({required String account}) async {
    final output =
        (await _jsEthersContract.balanceOf(account.toJS).toDart.catchError((e) {
      throw UserRejectedAction().tryParseError(e);
    }));

    return (BigInt.parse(output.toString()));
  }

  Future<BigInt> decimals() async {
    final output = (await _jsEthersContract.decimals().toDart.catchError((e) {
      throw UserRejectedAction().tryParseError(e);
    }));

    return (BigInt.parse(output.toString()));
  }
}

@JS('ethers.Contract')
extension type JSEthersContract._(JSObject _) implements JSObject {
  external JSEthersContract(
    JSString address,
    JSString abi,
    JSEthereumProvider provider,
  );

  external JSEthersContract.fromSigner(
    JSString address,
    JSString abi,
    JSEthersSigner signer,
  );

  external JSPromise<JSBigInt> balanceOf(JSString account);
  external JSPromise<JSBigInt> decimals();
}
