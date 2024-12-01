part of "../smart_contract_abi_builder.dart";

class _AbiContractImplGenerator {
  _AbiContractImplGenerator(this.className, this.abi);

  final String className;
  final SmartContractAbiDto abi;

  final String jsEthersContractFieldName = "_jsEthersContract";

  late final code = [
    _generateAbiImplClass(),
  ];

  Class _generateAbiImplClass() {
    return Class((c) {
      c.name = className;

      c.constructors.add(_generateConstructor());
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

  List<Field> _generateFields() {
    return [
      Field(
        (field) {
          field.modifier = FieldModifier.final$;
          field.name = jsEthersContractFieldName;
          field.type = refer(_JSEthersContractExtensionGenerator.extensionName);
        },
      ),
    ];
  }

  List<Method> get _generateAbiMethodsAsDart {
    final List<Method> abiMethods = [];
    final usedMethodNamesCount = <String, int>{};

    for (var entry in abi.entries) {
      if (entry.type != SmartContractAbiEntryType.function) continue;
      final bool hasMultipleOutputs = entry.outputs.length > 1;
      final bool isAllOutputsNamed = entry.outputs.every((output) => output.name.isNotEmpty);
      final String outputVariableName = entry.stateMutability.isView ? "output" : "tx";

      String returnType() {
        if (!entry.stateMutability.isView) return "<TransactionResponse>";
        final String maybeNamedTupleOpenString = isAllOutputsNamed ? "({" : "(";
        final String maybeNamedTupleCloseString = isAllOutputsNamed ? "})" : ")";
        final String maybeMultipleOutputOpenString = hasMultipleOutputs ? maybeNamedTupleOpenString : "";
        final String maybeMultipleOutputCloseString = hasMultipleOutputs ? maybeNamedTupleCloseString : "";

        return "<$maybeMultipleOutputOpenString ${entry.outputs.map((output) {
          return "${smartContractTypeToDartType(output)}${(isAllOutputsNamed && hasMultipleOutputs) ? " ${output.name}" : ""}";
        }).join(",")}$maybeMultipleOutputCloseString>";
      }

      String methodReturn() {
        if (entry.outputs.isEmpty && entry.stateMutability.isView) return "";
        if (!entry.stateMutability.isView) {
          return "return TransactionResponse.fromJS($outputVariableName);";
        }

        return "return (${entry.outputs.mapIndexed((index, output) {
          final getPropertyMethod = '.getProperty<${smartContractTypeToDartJSType(output.type)}>("$index".toJS)';
          final maybeNamedOutputString = (isAllOutputsNamed && hasMultipleOutputs) ? "${output.name}:" : "";
          final maybeAwait = entry.stateMutability.isView ? "" : "await";

          final isBigIntReturn = smartContractTypeToDartJSType(output.type) == (JSBigInt).toString();
          final outputAsJS = '$outputVariableName${hasMultipleOutputs ? getPropertyMethod : ""}';

          if (isBigIntReturn) {
            return "$maybeNamedOutputString BigInt.parse($outputAsJS.toString())";
          }

          return "$maybeNamedOutputString $maybeAwait $outputAsJS${!(entry.stateMutability.isView) ? ".wait()" : ""}.toDart";
        }).join(",")});";
      }

      abiMethods.add(Method((method) {
        usedMethodNamesCount[entry.name] = (usedMethodNamesCount[entry.name] ?? 0) + 1;
        final methodName = usedMethodNamesCount[entry.name]! > 1
            ? "${entry.name}${(usedMethodNamesCount[entry.name]! - 2)}"
            : entry.name;

        method.name = methodName;
        method.modifier = MethodModifier.async;

        if (usedMethodNamesCount[entry.name]! > 1) {
          method.docs.addAll([
            "/// [Warning]: Detected Duplicated Name, so renamed from [${entry.name}] to [${method.name}] to avoid conflicts and still make both methods available",
          ]);
        }

        if (entry.inputs.every((input) => input.name.isNotEmpty)) {
          method.optionalParameters.addAll(entry.inputs.map((input) {
            return Parameter((param) {
              param.name = input.name.removeUnderScores;
              param.named = true;
              param.required = true;
              param.type = refer(smartContractTypeToDartType(input));
            });
          }));
        } else {
          method.requiredParameters.addAll(entry.inputs.mapIndexed((index, input) {
            return Parameter((param) {
              final paramName = input.name.removeUnderScores;

              param.name = paramName.isNotEmpty ? paramName : "param$index";
              param.named = true;
              param.type = refer(smartContractTypeToDartType(input));
            });
          }));
        }

        method.returns = refer("Future${returnType()}");
        method.body = Code("""
        final $outputVariableName = (await $jsEthersContractFieldName.$methodName(${entry.inputs.mapIndexed((index, input) {
          final inputName = input.name.removeUnderScores.isNotEmpty ? input.name.removeUnderScores : "param$index";

          if (input.type == "tuple") {
            return "JSObject()${input.components.map((component) => '..setProperty("${component.name}".toJS, $inputName.${component.name}.toJS)').join("")}";
          }

          return "$inputName.toJS";
        }).join(",")}).toDart.catchError((e) {
      throw UserRejectedAction().tryParseError(e);
    })); 

        ${methodReturn()}
""");
      }));
    }
    return abiMethods;
  }
}
