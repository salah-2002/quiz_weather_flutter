import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'quiz.dart';
import 'weather.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  int _index = 0;

  final _pages = const [
    QuizPage(),
    WeatherPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEMO_APP',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(_index == 0 ? 'Quiz' : 'Weather')),
        body: _pages[_index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.quiz), label: 'Quiz'),
            NavigationDestination(icon: Icon(Icons.cloud), label: 'Weather'),
          ],
          onDestinationSelected: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}
