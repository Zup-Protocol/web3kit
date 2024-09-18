import "package:freezed_annotation/freezed_annotation.dart";
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
  }

  void dispatchEvent(Event event) {}

  void removeEventListener(String eventName, JSFunction callback) {}
}

class Cache {}

class Event {
  Event(this.type);

  final JSString type;
}
