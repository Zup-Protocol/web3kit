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
        method.requiredParameters.addAll(entry.inputs.map((input) {
          return Parameter((param) {
            param.name = input.name;
            param.named = true;
            param.type = refer(smartContractTypeToDartType(input.type));
          });
        }));
        method.returns = refer("Future${returnType()}");
        method.body = Code("""
        final output = (await $jsEthersContractFieldName.${entry.name}(${entry.inputs.map((input) => "${input.name}.toJS").join(",")}).toDart); 

        ${methodReturn()}
""");
      }));
    }
    return abiMethods;
  }
}
