part of "smart_contract_abi_builder.dart";

String smartContractTypeToDartJSType(String type) {
  if (type.startsWith("uint") || type.startsWith("int")) {
    return (JSBigInt).toString();
  }

  if (type.startsWith("address")) return (JSString).toString();
  if (type.startsWith("bool")) return (JSBoolean).toString();

  throw UnsupportedError("Unsupported type: $type");
}

String smartContractTypeToDartType(String type) {
  if (type.startsWith("uint") || type.startsWith("int")) {
    return (BigInt).toString();
  }

  if (type.startsWith("address")) return (String).toString();
  if (type.startsWith("bool")) return (bool).toString();

  throw UnsupportedError("Unsupported type: $type");
}
