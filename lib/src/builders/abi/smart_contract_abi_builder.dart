import "dart:async";
import "dart:convert";

import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:collection/collection.dart";
import "package:dart_style/dart_style.dart";
import "package:freezed_annotation/freezed_annotation.dart" hide literal;
import "package:web3kit/src/builders/abi/dtos/smart_contract_abi_dto/smart_contract_abi_dto.dart";
import "package:web3kit/src/builders/abi/dtos/smart_contract_abi_entry_dto/smart_contact_abi_entry_dto.dart";
import "package:web3kit/src/extensions/string_extension.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

part "utils.dart";

@protected
class SmartContractAbiBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => const {
        "abi.json": ["abi.g.dart"]
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final fileName = inputId.pathSegments.last.split(".").first;
    final sourceAbi = await buildStep.readAsString(inputId);

    final abi = SmartContractAbiDto.fromJson({
      SmartContractAbiDto.entriesJsonName: jsonDecode(sourceAbi),
    });

    final outputId = AssetId(inputId.package, inputId.changeExtension(".g.dart").path);
    return buildStep.writeAsString(outputId, generateDartAbi(abi, fileName, sourceAbi));
  }

  String generateDartAbi(SmartContractAbiDto abi, String fileName, String sourceAbi) {
    final className = fileName.toPascalCase;

    final generation = _Generator(abiContractClassName: className, abi: abi, sourceAbi: sourceAbi);

    final code = generation.generate();

    final emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      useNullSafetySyntax: true,
      orderDirectives: true,
    );

    final source = """
// coverage:ignore-file
// ignore_for_file: implementation_imports

import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) 'dart:js_interop';
import "package:web3kit/src/mocks/package_mocks/js_interop_unsafe_mock.dart" if (dart.library.html) 'dart:js_interop_unsafe';
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart" if (dart.library.html) "package:web3kit/src/js/ethereum_provider.js.dart";

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  Web3Kit
/// *****************************************************

${code.accept(emitter)}

""";

    final sourceWithManualFixes = source
        .replaceAll(
          "external ${_JSEthersContractExtensionGenerator.extensionName}._",
          "external ${_JSEthersContractExtensionGenerator.extensionName}",
        )
        .replaceAll(
          "external ${_JSEthersJsonRpcProviderGenerator.extensionName}._",
          "external ${_JSEthersJsonRpcProviderGenerator.extensionName}",
        );

    try {
      return DartFormatter().format(sourceWithManualFixes);
    } catch (e) {
      log.severe("Could not format generated code from ABI, this is likely a bug", e);
      return sourceWithManualFixes;
    }
  }
}

class _Generator {
  _Generator({required this.abiContractClassName, required this.abi, required this.sourceAbi});

  final String abiContractClassName;
  final SmartContractAbiDto abi;
  final String sourceAbi;

  Library generate() => Library(
        (library) {
          library.body.addAll(_AbiContractGenerator(abiContractClassName, abi, sourceAbi).code);
          library.body.addAll(_JSEthersContractExtensionGenerator(abi: abi).code);
          library.body.addAll(_JSEthersJsonRpcProviderGenerator().code);
        },
      );
}

class _AbiContractGenerator {
  _AbiContractGenerator(this.className, this.abi, this.sourceAbi);

  final String className;
  final String contractAddressParamName = "contractAddress";
  final String rpcUrlParamName = "rpcUrl";
  final String abiFieldName = "abi";
  final String jsEthersContractFieldName = "_jsEthersContract";
  final SmartContractAbiDto abi;
  final String sourceAbi;

  late final code = [
    _generateAbiClass(),
  ];

  Class _generateAbiClass() {
    return Class((c) {
      c.name = className;

      c.constructors.add(_generateConstructor());
      c.constructors.add(_generateRpcProviderFactory());
      c.constructors.add(_generateBrowserProviderFactory());
      c.fields.addAll(_generateFields());
      c.methods.addAll(_generateAbiMethodsAsDart);
    });
  }

  Constructor _generateConstructor() {
    return Constructor((constructor) {
      constructor.name = "_";
      constructor.requiredParameters.add(Parameter(
        (param) {
          param.toThis = true;

          param.name = jsEthersContractFieldName;
          param.type = refer(_JSEthersContractExtensionGenerator.extensionName);
        },
      ));
    });
  }

  Constructor _generateRpcProviderFactory() {
    return Constructor((constructor) {
      constructor.factory = true;
      constructor.name = "fromRpcProvider";

      constructor.docs.addAll([
        "/// Create a new instance of [$className] using the given RPC provider to make contract calls",
      ]);

      constructor.requiredParameters.addAll([
        Parameter(
          (param) {
            param.name = contractAddressParamName;
            param.type = refer("String");
          },
        ),
        Parameter(
          (param) {
            param.name = rpcUrlParamName;
            param.type = refer("String");
          },
        )
      ]);

      constructor.body = Block((code) {
        code.addExpression(
          refer("$className._").newInstance([
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
    });
  }

  Constructor _generateBrowserProviderFactory() {
    return Constructor((constructor) {
      constructor.factory = true;
      constructor.name = "fromBrowserProvider";

      constructor.docs.addAll([
        "/// Create a new instance of [$className] using a connected provider (e.g Metamask) to make contract calls",
      ]);

      constructor.requiredParameters.addAll([
        Parameter(
          (param) {
            param.name = contractAddressParamName;
            param.type = refer("String");
          },
        ),
        Parameter(
          (param) {
            param.name = "provider";
            param.type = refer("JSEthereumProvider");
          },
        ),
      ]);

      constructor.body = Block((code) {
        code.addExpression(
          refer("$className._").newInstance([
            refer(_JSEthersContractExtensionGenerator.extensionName).newInstance(
              [
                refer("$contractAddressParamName.toJS"),
                refer("$abiFieldName.toJS"),
                refer("provider"),
              ],
            ),
          ]).returned,
        );
      });
    });
  }

  List<Field> _generateFields() {
    return [
      Field(
        (field) {
          field.name = jsEthersContractFieldName;
          field.type = refer(_JSEthersContractExtensionGenerator.extensionName);
        },
      ),
      Field((field) {
        field.name = abiFieldName;
        field.static = true;
        field.type = refer("String");
        field.assignment = Code('"""$sourceAbi"""');
      })
    ];
  }

  List<Method> get _generateAbiMethodsAsDart {
    final List<Method> abiMethods = [];

    for (var entry in abi.entries) {
      if (entry.type != SmartContractAbiEntryType.function) continue;
      final bool hasMultipleOutputs = entry.outputs.length > 1;
      final bool isAllOutputsNamed = entry.outputs.every((output) => output.name.isNotEmpty);

      String returnType() {
        if (entry.outputs.isEmpty) return "<void>";
        final String maybeNamedTupleOpenString = isAllOutputsNamed ? "({" : "(";
        final String maybeNamedTupleCloseString = isAllOutputsNamed ? "})" : ")";
        final String maybeMultipleOutputOpenString = hasMultipleOutputs ? maybeNamedTupleOpenString : "";
        final String maybeMultipleOutputCloseString = hasMultipleOutputs ? maybeNamedTupleCloseString : "";

        return "<$maybeMultipleOutputOpenString ${entry.outputs.map((output) {
          return "${smartContractTypeToDartType(output.type)}${isAllOutputsNamed ? " ${output.name}" : ""}";
        }).join(",")}$maybeMultipleOutputCloseString>";
      }

      String methodReturn() {
        if (entry.outputs.isEmpty) return "";

        return "return (${entry.outputs.mapIndexed((index, output) {
          final getPropertyMethod = '.getProperty<${smartContractTypeToDartJSType(output.type)}>("$index".toJS)';
          final maybeNamedOutputString = isAllOutputsNamed ? "${output.name}:" : "";

          final isBigIntReturn = smartContractTypeToDartJSType(output.type) == (JSBigInt).toString();
          final outputAsJS = 'output${hasMultipleOutputs ? getPropertyMethod : ""}';

          if (isBigIntReturn) {
            return "$maybeNamedOutputString BigInt.parse($outputAsJS.toString())";
          }
          return "$maybeNamedOutputString $outputAsJS.toDart";
        }).join(",")});";
      }

      abiMethods.add(Method((method) {
        method.modifier = MethodModifier.async;
        method.name = entry.name;
        method.returns = refer("Future${returnType()}");
        method.body = Code("""
        final output = (await $jsEthersContractFieldName.${entry.name}().toDart); 

        ${methodReturn()}
""");
      }));
    }
    return abiMethods;
  }
}

class _JSEthersContractExtensionGenerator {
  _JSEthersContractExtensionGenerator({required this.abi});

  static const extensionName = r"JSEthersContract";
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
