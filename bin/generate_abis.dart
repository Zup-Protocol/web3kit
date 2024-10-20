import "package:build/build.dart";
import "package:build_runner/build_runner.dart";
import "package:build_runner_core/build_runner_core.dart";
import "package:web3kit/src/builders/builders.dart";

Future<void> main() async {
  // clean up the previously generated abis
  await run(
    ["clean"],
    [applyToRoot(smartContractAbiBuilder(const BuilderOptions({})))],
  );

  await run(
    ["build", "--config abis"],
    [applyToRoot(smartContractAbiBuilder(const BuilderOptions({})))],
  );
}
