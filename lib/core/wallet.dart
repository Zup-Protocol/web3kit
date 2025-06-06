import "dart:async";

import "package:collection/collection.dart";
import "package:web3kit/core/core.dart";
import "package:web3kit/core/exceptions/ethereum_request_exceptions.dart";
import "package:web3kit/core/exceptions/ethers_exceptions.dart";
import "package:web3kit/src/abis/erc_20.abi.g.dart";
import "package:web3kit/src/cache.dart";
import "package:web3kit/src/enums/eip_6963_event_enum.dart";
import "package:web3kit/src/enums/ethereum_request_error.dart";
import "package:web3kit/src/inject.dart";
import "package:web3kit/src/mocks/eip_6963_event.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/eip_6963/eip_6963_event.js.dart";
import "package:web3kit/src/mocks/ethereum_request_error.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethereum_request_error.js.dart";
import "package:web3kit/src/mocks/ethers_json_rpc_provider.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/ethers/ethers_json_rpc_provider.js.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/package_mocks/web_mock.dart" if (dart.library.html) "package:web/web.dart" hide Cache;
import "package:web3kit/src/mocks/rabby_request_error.js_mock.dart"
    if (dart.library.html) "package:web3kit/src/js/rabby_request_error.js.dart";
import "package:zup_core/zup_core.dart";

/// Object to interact with Web3 wallets.
/// Can perform actions like connect, verify if specific wallet is installed, etc...
class Wallet {
  Wallet(this._browserProvider, this._cache, this._window, this._erc20) {
    _getInstalledWallets();
    _setupStreams();
  }
  final BrowserProvider _browserProvider;
  final Cache _cache;
  final Window _window;
  final Erc20 _erc20;

  /// Access the singleton instance of the Wallet Object
  static Wallet get shared => Inject.shared.wallet;

  final StreamController<Signer?> _signerStreamController = StreamController<Signer?>.broadcast();
  final List<WalletDetail> _installedWallets = [];
  EthereumProvider? _connectedProvider;
  Signer? _signer;
  WalletDetail? _connectedWallet;

  /// Stream of the current connected signer
  ///
  /// Emitted every time an user change their account in the wallet. Such as connect, disconnect, change account etc...
  ///
  /// In case of disconnection, it will emit a null event
  Stream<Signer?> get signerStream => _signerStreamController.stream;

  /// Get the current signer.
  ///
  /// If no signer is connected, it will return null
  Signer? get signer => _signer;

  /// Get the list of installed wallets in the browser, it will include all wallets following the EIP 6963 standard.
  ///
  /// For more info about EIP 6963, please head over to https://eips.ethereum.org/EIPS/eip-6963
  List<WalletDetail> get installedWallets => List.unmodifiable(_installedWallets);

  /// Get the current connected wallet provider.
  ///
  /// Returns null if no wallet is connected
  EthereumProvider? get connectedProvider => _connectedProvider;

  /// Get the current connected wallet detail.
  ///
  /// Returns null if no wallet is connected
  WalletDetail? get connectedWallet => _connectedWallet;

  /// Get the current network of the connected wallet
  ///
  /// !Warning: This getter only works if a wallet is currently connected to the application.
  ///
  /// If you desire to get the network of a wallet that is not currently connected, use the [BrowserProvider]
  Future<ChainInfo> get connectedNetwork async {
    assert(_connectedProvider != null, "Wallet should be connected to get network");

    return await _browserProvider.getNetwork(_connectedProvider!);
  }

  void _setupStreams() async {
    for (var wallet in _installedWallets) {
      wallet.provider.onAccountsChanged((accounts) async {
        if (accounts.isEmpty) return await disconnect();

        await connect(wallet);
      });
    }
  }

  void _updateSigner(Signer? newSigner) async {
    _signer = newSigner;
    _signerStreamController.add(newSigner);
  }

  void _getInstalledWallets() {
    final eventCallback = (JSEIP6963Event event) {
      _installedWallets.add(
        WalletDetail(
          info: WalletInfo(
            name: event.detail.info.name.toDart,
            icon: event.detail.info.icon.toDart,
            rdns: event.detail.info.rdns.toDart,
          ),
          provider: EthereumProvider(event.detail.provider),
        ),
      );
    }.toJS;

    _window.addEventListener(EIP6963EventEnum.announceProvider.name, eventCallback);
    _window.dispatchEvent(JSEIP6963Event(EIP6963EventEnum.requestProvider.name.toJS));
    _window.removeEventListener(EIP6963EventEnum.announceProvider.name, eventCallback);
  }

  /// Switch the current wallet's chain to the given chain Id.
  /// !Warning: This method only works if a wallet is currently connected to the application
  ///
  /// @param `hexChainId` the chainId to switch in Hex String. E.g, Ethereum mainnet has an ChainId 1, then it will be "0x1"
  ///
  /// @throws [UnrecognizedChainId] if the chainId is not recognized by the wallet (It's either not supported or not added yet).
  /// In case of the error [UnrecognizedChainId], you can use the method [addNetwork] instead, to add the chain to the wallet (if supported).
  Future<void> switchNetwork(String hexChainId) async {
    assert(_connectedProvider != null, "Wallet should be connected to switch network");

    try {
      await _connectedProvider!.switchChain(hexChainId);
      _updateSigner(await _browserProvider.getSigner(_connectedProvider!));
    } catch (e) {
      bool isEthereumRequestError = (e is JSEthereumRequestError);
      bool isUnrecognizedChainIdError =
          isEthereumRequestError && (e).code.toDartInt.equals(EthereumRequestError.unrecognizedChainId.code);

      if (isUnrecognizedChainIdError) throw UnrecognizedChainId(hexChainId);

      // Rabby Wallet throws a different error when the chain is unrecognized.
      // We need to check if the wallet is Rabby and then act accordingly
      if (_connectedWallet!.info.rdns == "io.rabby" && e is JSRabbyRequestError) {
        if (e.data.originalError?.code.toDartInt.equals(EthereumRequestError.unrecognizedChainId.code) ?? false) {
          throw UnrecognizedChainId(hexChainId);
        }
      }

      rethrow;
    }
  }

  /// Add a new network to the connected wallet
  /// !Warning: This method only works if a wallet is currently connected to the application
  ///
  /// @param `network` the information about the network to be added.
  Future<void> addNetwork(ChainInfo network) async {
    assert(_connectedProvider != null, "Wallet should be connected to add network");

    await _connectedProvider!.addChain(network);
    _updateSigner(await _browserProvider.getSigner(_connectedProvider!));
  }

  /// Try to switch the current wallet chain to the given chain. But if the chain is not added yet in the wallet,
  /// it will ask to add a new chain
  ///
  /// This method in general is a combination of the methods [switchNetwork] and [addNetwork]. That you can also use
  Future<void> switchOrAddNetwork(ChainInfo network) async {
    try {
      await switchNetwork(network.hexChainId);
    } catch (e) {
      if (e is UnrecognizedChainId) return addNetwork(network);

      rethrow;
    }
  }

  /// Connect to a wallet that was connected, and wasn't disconnected in the same session.
  /// If there are no previous cached connections, it will return `null` as the Signer.
  ///
  /// This method is useful to keep a user wallet connected between sessions, without asking
  /// him to connect again.
  Future<Signer?> connectCachedWallet() async {
    String? cachedConnectedWalletRDNS = await _cache.getConnectedWallet();

    WalletDetail? connectedWallet = _installedWallets.firstWhereOrNull((wallet) {
      return wallet.info.rdns == cachedConnectedWalletRDNS;
    });

    return connectedWallet != null ? connect(connectedWallet) : null;
  }

  /// Connect to a specific wallet.
  ///
  /// `wallet` is the intended wallet to connect. You can get this in the `installedWallets` property of this class
  Future<Signer> connect(WalletDetail wallet) async {
    try {
      final newSigner = await _browserProvider.getSigner(wallet.provider);
      _connectedProvider = wallet.provider;
      _connectedWallet = wallet;

      _updateSigner(newSigner);

      _cache.setWalletConnectionState(wallet.info.rdns);
      return newSigner;
    } catch (e) {
      throw UserRejectedAction().tryParseError(e);
    }
  }

  /// Disconnect from the current connected wallet
  Future<void> disconnect() async {
    if (signer != null) _updateSigner(null);

    await _cache.setWalletConnectionState(null);

    try {
      await _connectedProvider!.revokePermissions();
    } catch (_) {
      // as it will revert if the current connected wallet did not implement MIP-2 standard
      // we can safely ignore the error
    }

    _connectedProvider = null;
  }

  /// Get a specific token balance of the connected wallet.
  ///
  /// `tokenAddress` is the address of the token to get the balance of.
  ///
  /// if the `rpcUrl` is provided, it will use the `rpcUrl` to get the balance.
  /// Otherwise, it will use the `signer` to get the balance, note that the `signer`
  /// must be in the same network as the token, to ensure it, you can use [switchNetwork].
  /// If the user network is not the same as the token network, it will throw an error
  ///
  /// Note that it will return the balance with common decimals
  /// (e.g `1.0` instead of `1000000000000000000`)
  Future<double> tokenBalance(String tokenAddress, {String? rpcUrl}) async {
    assert(signer != null, "Wallet should be connected to get token balance");

    Erc20Impl contract;

    if (rpcUrl != null) {
      contract = _erc20.fromRpcProvider(contractAddress: tokenAddress, rpcUrl: rpcUrl);
    } else {
      contract = _erc20.fromSigner(contractAddress: tokenAddress, signer: signer!);
    }

    final balance = await contract.balanceOf(account: await signer!.address);
    final tokenDecimals = (await contract.decimals()).toInt();
    final balanceParsed = balance.parseTokenAmount(decimals: tokenDecimals);

    return balanceParsed;
  }

  /// Get the native (e.g Ether, AVAX, BNB) balance of the connected wallet in converted decimals (e.g 1000000 -> `1.0`).
  ///
  /// If the `rpcUrl` is provided, it will use the `rpcUrl` to get the balance.
  /// Otherwise, it will use the connected provider to get the balance.
  /// (Note that if using the connected provider, it will only work if the wallet
  /// is connected in the same network as thet intended to query, you can use [switchNetwork] to ensure that)
  Future<double> nativeBalance({String? rpcUrl}) async {
    assert(signer != null, "Wallet should be connected to get native currency balance");

    BigInt weiBalance = BigInt.zero;

    if (rpcUrl != null) {
      final provider = JSEthersJsonRpcProvider(rpcUrl.toJS);
      weiBalance = BigInt.parse((await provider.getBalance((await signer!.address).toJS).toDart).toString());
    } else {
      weiBalance = BigInt.parse(
        (await connectedProvider!.jsEthereumProvider.getBalance((await signer!.address).toJS).toDart).toString(),
      );
    }

    return weiBalance.parseTokenAmount(decimals: 18);
  }

  /// Get the balance of a specific ERC20 token or the native currency (e.g ETH) balance of the connected wallet.
  /// Intended to be used when both native and token balances are needed, and you don't want to
  /// split the logic between the two methods.
  ///
  /// `tokenAddress` is the address of the token to get the balance of. If passed as zero address,
  ///  it will get the native balance, otherwise it will get the ERC20 token balance of the `tokenAddress`.
  ///
  /// If the `rpcUrl` is provided, it will use the `rpcUrl` to get the balance.
  /// Otherwise, it will use the connected provider to get the balance
  Future<double> nativeOrTokenBalance(String tokenAddress, {String? rpcUrl}) async {
    assert(signer != null, "Wallet should be connected to get balances from");

    if (tokenAddress == EthereumConstants.zeroAddress) return nativeBalance(rpcUrl: rpcUrl);

    return tokenBalance(tokenAddress, rpcUrl: rpcUrl);
  }
}
