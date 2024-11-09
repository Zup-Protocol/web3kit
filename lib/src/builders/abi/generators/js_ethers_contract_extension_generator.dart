part of "../smart_contract_abi_builder.dart";

class _JSEthersContractExtensionGenerator {
  _JSEthersContractExtensionGenerator({required this.abi});

  static const extensionName = r"JSEthersContract";
  static const fromSignerFactoryName = r"fromSigner";
  final SmartContractAbiDto abi;

  late final code = [
    _generateExtensionType(),
  ];

  ExtensionType _generateExtensionType() {
    return ExtensionType(
      (extensionType) {
        extensionType.name = "$extensionName._";

        extensionType.implements.add(refer("JSObject"));

        extensionType.representationDeclaration = RepresentationDeclaration((representation) {
          representation.name = "_";
          representation.declaredRepresentationType = refer("JSObject");
        });
        extensionType.annotations.add(refer("JS").newInstance([literal("ethers.Contract")]));
        extensionType.constructors.add(_generateContructor());
        extensionType.constructors.add(_generateFromSignerFactory());
        extensionType.methods.addAll(_generateAbiMethodsAsDartJS);
      },
    );
  }

  Constructor _generateContructor() {
    return Constructor((constructor) {
      constructor.external = true;

      constructor.requiredParameters.addAll([
        Parameter((param) {
          param.name = "address";
          param.type = refer("JSString");
        }),
        Parameter((param) {
          param.name = "abi";
          param.type = refer("JSString");
        }),
        Parameter((param) {
          param.name = "provider";
          param.type = refer("JSEthereumProvider");
        })
      ]);
    });
  }

  Constructor _generateFromSignerFactory() {
    return Constructor((constructor) {
      constructor.external = true;
      constructor.factory = true;
      constructor.name = "fromSigner";

      constructor.requiredParameters.addAll([
        Parameter((param) {
          param.name = "address";
          param.type = refer("JSString");
        }),
        Parameter((param) {
          param.name = "abi";
          param.type = refer("JSString");
        }),
        Parameter((param) {
          param.name = "signer";
          param.type = refer("JSEthersSigner");
        }),
      ]);
    });
  }

  List<Method> get _generateAbiMethodsAsDartJS {
    final List<Method> abiMethods = [];

    for (var entry in abi.entries) {
      if (entry.type != SmartContractAbiEntryType.function) continue;
      final bool entryHasMultipleOutputs = entry.outputs.length > 1;

      String returnType() {
        if (entry.outputs.isEmpty) return "";
        if (entryHasMultipleOutputs) return "<JSObject>";

        return "<${smartContractTypeToDartJSType(entry.outputs.first.type)}>";
      }

      abiMethods.add(Method((method) {
        method.external = true;
        method.name = entry.name;
        method.requiredParameters.addAll(entry.inputs.map((input) {
          return Parameter((param) {
            param.name = input.name;
            param.type = refer(smartContractTypeToDartJSType(input.type));
          });
        }));
        method.returns = refer("JSPromise${returnType()}");
      }));
    }

    return abiMethods;
  }

  //  [
  //       Method((method) {
  //         method.external = true;
  //         method.name = "factory";
  //         method.returns = refer("JSPromise<JSString>");
  //       }),
  //     ];
}
