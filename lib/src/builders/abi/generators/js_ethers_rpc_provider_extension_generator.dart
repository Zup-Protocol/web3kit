part of "../smart_contract_abi_builder.dart";

class _JSEthersJsonRpcProviderGenerator {
  static const extensionName = r"JSEthersJsonRpcProvider";

  late final code = [
    _generateExtensionType(),
  ];

  ExtensionType _generateExtensionType() {
    return ExtensionType(
      (extensionType) {
        extensionType.name = "$extensionName._";
        extensionType.implements.add(refer("JSEthereumProvider"));

        extensionType.representationDeclaration = RepresentationDeclaration((representation) {
          representation.name = "_";
          representation.declaredRepresentationType = refer("JSEthereumProvider");
        });
        extensionType.annotations.add(refer("JS").newInstance([literal("ethers.JsonRpcProvider")]));
        extensionType.constructors.add(Constructor((constructor) {
          constructor.external = true;

          constructor.requiredParameters.addAll([
            Parameter((param) {
              param.name = "rpcUrl";
              param.type = refer("JSString");
            })
          ]);
        }));
      },
    );
  }
}
