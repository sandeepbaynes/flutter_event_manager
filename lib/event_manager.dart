library event_manager;

/// Author: Sandeep Baynes
/// This code creates a simple event handler for Flutter
/// Events are registered or removed using the Event Manager class
/// Events are triggered using the Event Manager class
/// Event data and source are stored a data in an Event object

/// This class defines an event data type. The data within this event is generic
class Event {
  Object? data;
  Object? source;
  Event({this.data, this.source});
}

/// The event manager class contains the functions to register or remove handlers and also trigger an event call
/// A handler must have an event name. When an event is triggered, the data in the event needs to be cast to the specific type in the event handler
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
  /// Event data is optional. However, if the data is present, the type should be casted in the handler before using
  /// The source is an optional parameter indicating a trigger source. This is useful if a handler needs to filter the event based on the source
  static void trigger(String name, [Object? data, Object? source]) {
    if (_eventRegistry.containsKey(name)) {
      for (var handler in _eventRegistry[name]!) {
        if (data != null || source != null) {
          Event event = Event(data: data, source: source);
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
