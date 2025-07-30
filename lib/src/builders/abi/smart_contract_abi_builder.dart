import "dart:async";
import "dart:convert";

import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:collection/collection.dart";
import "package:dart_style/dart_style.dart";
import "package:freezed_annotation/freezed_annotation.dart" hide literal;
import "package:intl/intl.dart";
import "package:web3kit/src/builders/abi/dtos/smart_contract_abi_dto/smart_contract_abi_dto.dart";
import "package:web3kit/src/builders/abi/dtos/smart_contract_abi_entry_dto/smart_contact_abi_entry_dto.dart";
import "package:web3kit/src/builders/abi/dtos/smart_contract_abi_signature_dto/smart_contract_abi_signature_dto.dart";
import "package:web3kit/src/extensions/string_extension.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";

part "generators/abi_contract_impl_generator.dart";
part "generators/abi_contract_instance_generator.dart";
part "generators/js_ethers_contract_extension_generator.dart";
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

    final generation = _Generator(abiContractClassName: className, abi: abi, stringAbi: sourceAbi);

    final code = generation.generate();

    final emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      useNullSafetySyntax: true,
      orderDirectives: true,
    );

    final source = """
// coverage:ignore-file
// ignore_for_file: implementation_imports

import "package:web3kit/core/exceptions/ethers_exceptions.dart";
import "package:web3kit/core/ethereum_calldata_encoder.dart";
import "package:web3kit/core/signer.dart";
import "package:web3kit/src/extensions/bigint_extension.dart";
import "package:web3kit/src/extensions/list_extension.dart";
import "package:web3kit/core/dtos/transaction_response.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart" if (dart.library.html) "dart:js_interop";
import "package:web3kit/src/mocks/package_mocks/js_interop_unsafe_mock.dart" if (dart.library.html) "dart:js_interop_unsafe";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart" if (dart.library.html) "package:web3kit/src/js/ethereum_provider.js.dart";
import "package:web3kit/src/mocks/ethers_signer.js_mock.dart" if (dart.library.html) "package:web3kit/src/js/ethers/ethers_signer.js.dart";
import "package:web3kit/src/mocks/utils.js_mock.dart" if (dart.library.html) "package:web3kit/src/js/utils.js.dart";
import "package:web3kit/src/mocks/ethers_contract_transaction_response.js_mock.dart" if (dart.library.html) "package:web3kit/src/js/ethers/ethers_contract_transaction_response.js.dart";
import "package:web3kit/src/mocks/ethers_json_rpc_provider.js_mock.dart" if (dart.library.html) "package:web3kit/src/js/ethers/ethers_json_rpc_provider.js.dart";

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
          "external factory ${_JSEthersContractExtensionGenerator.extensionName}._",
          "external ${_JSEthersContractExtensionGenerator.extensionName}",
        );

    try {
      return DartFormatter(languageVersion: DartFormatter.latestLanguageVersion).format(sourceWithManualFixes);
    } catch (e) {
      log.severe("Could not format generated code from ABI, this is likely a bug", e);
      return sourceWithManualFixes;
    }
  }
}

class _Generator {
  _Generator({required this.abiContractClassName, required this.abi, required this.stringAbi});

  final String abiContractClassName;
  final SmartContractAbiDto abi;
  final String stringAbi;

  late final abiImplClassName = "${abiContractClassName}Impl";

  Library generate() {
    return Library(
      (library) {
        library.body.addAll(_AbiContractInstanceGenerator(
          abi: abi,
          abiAsString: stringAbi,
          className: abiContractClassName,
          implClassName: abiImplClassName,
        ).code);

        library.body.addAll(_AbiContractImplGenerator(abiImplClassName, abi).code);
        library.body.addAll(_JSEthersContractExtensionGenerator(abi: abi).code);
      },
    );
  }
}
