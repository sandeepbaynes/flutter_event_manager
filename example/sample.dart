import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:event_manager/event_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    EventManager.registerHandler(
        name: 'string_test',
        handler: (event) {
          if (event != null) {
            log('String event: ${(event.data) as String}');
          }
        });
    EventManager.registerHandler(name: 'custom_test', handler: customHandler);
    super.initState();
  }

  void _incrementCounter() {
    EventManager.trigger('string_test', 'Test event!');
    if (_counter % 5 == 0) {
      EventManager.trigger('custom_test');
    } else if (_counter % 2 == 0) {
      EventManager.trigger('custom_test', MyTestClass(_counter, 'Custom data'));
    }
    if (_counter == 15) {
      log('removing custom event');
      EventManager.removeHandler(name: 'custom_test', handler: customHandler);
    }
    setState(() {
      _counter++;
    });
  }

  void customHandler(event) {
    Event? e = event as Event?;
    if (e != null) {
      MyTestClass data = (e.data) as MyTestClass;
      log('Custom event: ${data.a} | ${data.b}');
    } else {
      log('Custom event without data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyTestClass {
  int a;
  String b;

  MyTestClass(this.a, this.b);

  int get aval {
    return a;
  }

  String get bval {
    return b;
  }
}
