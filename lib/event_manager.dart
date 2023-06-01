library flutter_event_manager;

/// Author: Sandeep Baynes
/// This code creates a simple event handler for Flutter
/// Events are registered or removed using the Event Manager class
/// Events are triggered using the Event Manager class
/// Event data is stored a data in an Event object

/// This class defines an event data type. The data within this event is generic
class Event {
  Object data;
  Event({required this.data});
}

/// The event manager class contains the functions to register or remove handlers and also trigger an event call
/// A handler must have an event name. When an event is triggered, the data logged by the event needs to match the type of event of the handler
/// All handlers of an event should have the same event type. Or else a runtime error is thrown
/// Multiple handlers can be registered for any event. They are all called in the order of registration
class EventManager {
  static final Map<String, List<void Function(Event? event)>> _eventRegistry =
      {};

  /// Registers a handler for an event name. If an event doesn't exist, it will be created
  /// If the same handler is registered more than once, the handler registration is ignored
  static void registerHandler(
      {required String name, required void Function(Event? event) handler}) {
    if (!_eventRegistry.containsKey(name)) {
      _eventRegistry[name] = [handler];
    } else if (!_eventRegistry[name]!.contains(handler)) {
      _eventRegistry[name]!.add(handler);
    }
  }

  /// Removes a handler for a specified event
  /// If the event or handler doesn't exist, an Exception is thrown
  /// Note that the handler is passed as reference to the function
  static void removeHandler(
      {required String name, required void Function(Event? event) handler}) {
    if (!_eventRegistry.containsKey(name)) {
      throw NoEventException();
    } else if (!_eventRegistry[name]!.contains(handler)) {
      throw NoHandlerException();
    } else {
      _eventRegistry[name]!.remove(handler);
    }
  }

  /// Triggers a specific event. No exception is thrown even if the event is not registered
  /// Event data is optional. However, if the data is present, the type should be the same as what the handlers have registered
  static void trigger(String name, [Object? data]) {
    if (_eventRegistry.containsKey(name)) {
      for (var handler in _eventRegistry[name]!) {
        if (data != null) {
          Event event = Event(data: data);
          handler(event);
        } else {
          handler(null);
        }
      }
    }
  }
}

class NoHandlerException implements Exception {}

class NoEventException implements Exception {}
