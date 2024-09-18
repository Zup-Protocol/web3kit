import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/src/mocks/eip_6963_detail_info.js_mock.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart";

@internal
class JSEIP6963Detail {
  const JSEIP6963Detail([this.info = const JSEIP6963DetailInfo(), this.provider = const JSEthereumProvider()]);

  final JSEIP6963DetailInfo info;
  final JSEthereumProvider provider;
}
