import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastLocation',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(child: Text('FastLocation')),
      ),
    );
  }
}