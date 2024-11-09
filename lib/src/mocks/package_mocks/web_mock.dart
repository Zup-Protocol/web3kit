// coverage:ignore-file

import "package:freezed_annotation/freezed_annotation.dart";
import "package:web3kit/src/enums/eip_6963_event_enum.dart";
import "package:web3kit/src/mocks/eip_6963_detail.js_mock.dart";
import "package:web3kit/src/mocks/eip_6963_detail_info.js_mock.dart";
import "package:web3kit/src/mocks/eip_6963_event.js_mock.dart";
import "package:web3kit/src/mocks/ethereum_provider.js_mock.dart";
import "package:web3kit/src/mocks/package_mocks/js_interop_mock.dart";

Window get window => Window();

@internal
class Window {
  List<Event> callbackParams = [];

  void setAddEventListenerCallbackParam(Event event) {
    callbackParams.add(event);
  }

  void addEventListener(String eventName, JSFunction callback) {
    for (var event in callbackParams) {
      callback.dartFunction(event);
    }

    if (eventName == EIP6963EventEnum.announceProvider.name) {
      callback.dartFunction(
        JSEIP6963Event(
            "".toJS,
            JSEIP6963Detail(
              JSEIP6963DetailInfo("Mock Wallet".toJS, "".toJS, "io.rdns".toJS),
              const JSEthereumProvider(),
            )),
      );
    }
  }

  void dispatchEvent(Event event) {}

  void removeEventListener(String eventName, JSFunction callback) {}
}

class Cache {}

class Event {
  Event(this.type);

  final JSString type;
}
