import "package:test/test.dart";
import "package:web3kit/src/enums/eip_6963_event_enum.dart";

void main() {
  test(".name extension should return the correct name", () {
    expect(EIP6963EventEnum.requestProvider.name, "eip6963:requestProvider");
    expect(EIP6963EventEnum.announceProvider.name, "eip6963:announceProvider");
  });
}
