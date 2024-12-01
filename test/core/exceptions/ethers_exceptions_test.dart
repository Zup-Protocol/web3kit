import "package:flutter_test/flutter_test.dart";
import "package:web3kit/core/exceptions/ethers_exceptions.dart";
import "package:web3kit/src/mocks/ethers_errors.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

class EthersExceptionsTestWrapper extends EthersException<EthersExceptionsTestWrapper> {
  @override
  String get errorCode => "TEST_CODE";
}

void main() {
  test(
    "When using `tryParseError` and passing a object that is not an jsEthersError, it should rethrow the error",
    () {
      final notEthersError = StateError("Dale");

      expect(
        () => EthersExceptionsTestWrapper().tryParseError(notEthersError),
        throwsA(notEthersError),
      );
    },
  );

  test(
    """When using `tryParseError` and passing a object that is an JSEthersError,
    but with a different code, it should rethrow the error""",
    () {
      const code = "some-random-code";
      final ethersError = JSEthersError(code.toJS);

      expect(
        () => EthersExceptionsTestWrapper().tryParseError(ethersError),
        throwsA(ethersError),
      );
    },
  );

  test(
    """When using `tryParseError` and passing a object that is an JSEthersError,
    with the same code, it should return the EthersException class""",
    () {
      final ethersError = JSEthersError(EthersExceptionsTestWrapper().errorCode.toJS);

      expect(
        () => EthersExceptionsTestWrapper().tryParseError(ethersError),
        throwsA(isA<EthersExceptionsTestWrapper>()),
      );
    },
  );
}
