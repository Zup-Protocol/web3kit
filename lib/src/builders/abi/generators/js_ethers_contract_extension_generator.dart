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
    final usedEntryNames = <String, int>{};

    for (var entry in abi.entries) {
      final entryNameIsDuplicated = (usedEntryNames[entry.name] ?? 0) >= 1;
      usedEntryNames[entry.name] = (usedEntryNames[entry.name] ?? 0) + 1;

      if (entry.type != SmartContractAbiEntryType.function) continue;
      final bool entryHasMultipleOutputs = entry.outputs.length > 1;

      String returnType() {
        if (!entry.stateMutability.isView) return "<JSEthersContractTransactionResponse>";
        if (entryHasMultipleOutputs) return "<JSObject>";

        return "<${smartContractTypeToDartJSType(entry.outputs.first.type)}>";
      }

      abiMethods.add(Method((method) {
        method.external = true;
        if (entryNameIsDuplicated) method.annotations.add(refer("JS").newInstance([literal(entry.name)]));
        method.name = entryNameIsDuplicated ? "${entry.name}${usedEntryNames[entry.name]! - 2}" : entry.name;
        method.requiredParameters.addAll([
          ...entry.inputs.mapIndexed((index, input) {
            return Parameter((param) {
              param.name = input.name.isEmpty ? "param$index" : input.name;
              param.type = refer(
                smartContractTypeToDartJSType(
                  input.type,
                  isTransaction: entry.stateMutability != SmartContractStateMutability.view,
                ),
              );
            });
          }),
          if (entry.stateMutability.isPayable)
            Parameter((param) {
              param.name = "overrides";
              param.type = refer("JSObject");
              param.required = false;
            })
        ]);
        method.returns = refer("JSPromise${returnType()}");
      }));
    }

    return abiMethods;
  }
}
