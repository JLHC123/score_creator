import 'package:flutter/material.dart';
import 'package:score_creator/LoginScreen.dart';
import 'package:score_creator/GlobalScoreScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen()
    );
  }
}