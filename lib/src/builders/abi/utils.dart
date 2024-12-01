part of "smart_contract_abi_builder.dart";

String smartContractTypeToDartJSType(String type, {bool isTransaction = false}) {
  if (type.startsWith("uint") || type.startsWith("int")) return (JSBigInt).toString();
  if (type.startsWith("address")) return (JSString).toString();
  if (type.startsWith("bool")) return (JSBoolean).toString();
  if (type.startsWith("string")) return (JSString).toString();
  if (type.startsWith("tuple")) return (JSObject).toString();
  if (type.startsWith("bytes")) return (JSString).toString();

  throw UnsupportedError("Unsupported abi type -> $type");
}

String smartContractTypeToDartType(SmartContractAbiSignatureDto abiSignature) {
  final type = abiSignature.type;

  if (type.startsWith("uint") || type.startsWith("int")) {
    return (BigInt).toString();
  }

  if (type.startsWith("address")) return (String).toString();
  if (type.startsWith("bool")) return (bool).toString();
  if (type.startsWith("string")) return (String).toString();
  if (type.startsWith("bytes")) return (String).toString();
  if (type.startsWith("tuple")) {
    final maybeNamedTupleOpen = abiSignature.components.every((component) => component.name.isNotEmpty) ? "{" : "";
    final maybeNamedTupleClose = abiSignature.components.every((component) => component.name.isNotEmpty) ? "}" : "";

    return ("($maybeNamedTupleOpen ${abiSignature.components.map((componentSignature) {
      return "${smartContractTypeToDartType(componentSignature)} ${componentSignature.name}";
    }).join(",")} $maybeNamedTupleClose)");
  }

  throw UnsupportedError("Unsupported abi type -> $type");
}
