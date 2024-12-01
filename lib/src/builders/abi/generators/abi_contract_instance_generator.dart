part of "../smart_contract_abi_builder.dart";

class _AbiContractInstanceGenerator {
  _AbiContractInstanceGenerator({
    required this.className,
    required this.abiAsString,
    required this.implClassName,
    required this.abi,
  });

  final String className;
  final String implClassName;
  final String abiAsString;
  final SmartContractAbiDto abi;

  final String contractAddressParamName = "contractAddress";
  final String signerParamName = "signer";
  final String rpcUrlParamName = "rpcUrl";
  final String abiFieldName = "abi";

  late final code = [_generateAbiInstanceClass()];

  Class _generateAbiInstanceClass() => Class(
        (c) {
          c.name = className;
          c.methods.addAll(methods);
          c.fields.addAll(_generateFields());
        },
      );

  List<Field> _generateFields() {
    return [
      Field((field) {
        field.name = abiFieldName;
        field.static = true;
        field.type = refer("String");
        field.assignment = Code('"""$abiAsString"""');
      }),
    ];
  }

  List<Method> get methods {
    List<Method> methods = [];

    methods.add(Method((method) {
      method.name = "fromRpcProvider";
      method.returns = refer(implClassName);
      method.docs.addAll([
        "/// Create a new instance of [$className] using the given RPC provider to make contract calls",
      ]);

      method.optionalParameters.addAll([
        Parameter(
          (param) {
            param.named = true;
            param.required = true;
            param.name = contractAddressParamName;
            param.type = refer("String");
          },
        ),
        Parameter(
          (param) {
            param.named = true;
            param.required = true;
            param.name = rpcUrlParamName;
            param.type = refer("String");
          },
        )
      ]);

      method.body = Block((code) {
        code.addExpression(
          refer("$implClassName._").newInstance([
            refer(_JSEthersContractExtensionGenerator.extensionName).newInstance(
              [
                refer("$contractAddressParamName.toJS"),
                refer("$abiFieldName.toJS"),
                refer(_JSEthersJsonRpcProviderGenerator.extensionName).newInstance([
                  refer("$rpcUrlParamName.toJS"),
                ]),
              ],
            ),
          ]).returned,
        );
      });
    }));

    methods.add(Method((method) {
      method.name = "fromSigner";
      method.returns = refer(implClassName);
      method.docs.addAll([
        "/// Create a new instance of [$className] using a connected signer to make contract calls",
      ]);

      method.optionalParameters.addAll([
        Parameter(
          (param) {
            param.named = true;
            param.required = true;
            param.name = contractAddressParamName;
            param.type = refer("String");
          },
        ),
        Parameter(
          (param) {
            param.named = true;
            param.required = true;
            param.name = "signer";
            param.type = refer("Signer");
          },
        ),
      ]);

      method.body = Block((code) {
        code.addExpression(
          refer("$implClassName._").newInstance([
            refer(_JSEthersContractExtensionGenerator.extensionName).newInstanceNamed(
              _JSEthersContractExtensionGenerator.fromSignerFactoryName,
              [
                refer("$contractAddressParamName.toJS"),
                refer("$abiFieldName.toJS"),
                refer("$signerParamName.ethersSigner"),
              ],
            ),
          ]).returned,
        );
      });
    }));

    methods.addAll(generateCalldataMethods());

    return methods;
  }

  List<Method> generateCalldataMethods() {
    final calldataFields =
        abi.entries.where((entry) => entry.type.isFunction && !entry.stateMutability.isView).toList();
    final usedMethodNamesCount = <String, int>{};

    return List.generate(
      calldataFields.length,
      (index) => Method(
        (method) {
          usedMethodNamesCount[calldataFields[index].name] =
              (usedMethodNamesCount[calldataFields[index].name] ?? 0) + 1;

          method.name =
              "get${toBeginningOfSentenceCase(calldataFields[index].name)}${usedMethodNamesCount[calldataFields[index].name]! > 1 ? (usedMethodNamesCount[calldataFields[index].name]! - 2) : ""}Calldata";

          method.returns = refer("String");

          if (usedMethodNamesCount[calldataFields[index].name]! > 1) {
            method.docs.addAll([
              "/// [Warning]: Detected Duplicated Name, so renamed to [${method.name}] to avoid conflicts, and still make both methods available",
            ]);
          }

          if (calldataFields[index].inputs.every((input) => input.name.isEmpty)) {
            method.requiredParameters.addAll(calldataFields[index].inputs.map((input) {
              return Parameter((param) {
                param.name = input.name.removeUnderScores;
                param.type = refer(smartContractTypeToDartType(input));
              });
            }));
          } else {
            method.optionalParameters.addAll(calldataFields[index].inputs.map((input) {
              return Parameter((param) {
                param.named = true;
                param.required = true;
                param.name = input.name.removeUnderScores;
                param.type = refer(smartContractTypeToDartType(input));
              });
            }));
          }

          method.body = Block((code) {
            code.addExpression(refer("EthereumCalldataEncoder").property("encodeWithSignature").call(
              [],
              {
                "signature": literal(
                  "${calldataFields[index].name}(${calldataFields[index].inputs.map((input) {
                    if (input.type == "tuple") {
                      return "(${input.components.map((component) => component.type).join(",")})";
                    }

                    return input.type;
                  }).join(",")})",
                ),
                "params": refer(
                  "[${calldataFields[index].inputs.map((input) {
                    if (input.type == "tuple") {
                      return "[${input.components.map((component) => "${input.name.removeUnderScores}.${component.name.removeUnderScores}").join(",")}]";
                    }
                    return input.name.removeUnderScores;
                  }).join(",")}]",
                ),
              },
            ).returned);
          });
        },
      ),
    );
  }
}
