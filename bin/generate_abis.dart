import "package:build_runner/build_runner.dart";
import "package:build_runner_core/build_runner_core.dart";
import "package:web3kit/src/builders/builders.dart";

Future<void> main() async {
  await run(["build", "--config abis", "--delete-conflicting-outputs"], [applyToRoot(smartContractAbiBuilder())]);
}
