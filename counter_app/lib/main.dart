import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Практическая работа: Счётчик',
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);
  void _decrement() => setState(() => _counter--);
  void _reset() => setState(() => _counter = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Счётчик')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Текущее значение:', style: TextStyle(fontSize: 20)),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _decrement, child: const Text('-')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _increment, child: const Text('+')),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _reset, child: const Text('Сбросить')),
          ],
        ),
      ),
    );
  }
}
