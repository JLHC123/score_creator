import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';

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
      home: const ScoreScreen(),
    );
  }
}

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  List<dynamic> scores = [];

  // Helper function to switch between Web and Emulator
  String getBaseUrl() {
    if (kIsWeb) {
      return 'https://localhost:7240'; // Edge
    } else {
      return 'https://10.0.2.2:7240'; // Android Emulator
    }
  }

  Future<void> fetchScores() async {
    http.Client client;

    if (kReleaseMode || kIsWeb) {
      client = http.Client();
    } else {
      final ioc = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      client = IOClient(ioc);
    }

    try {
      final response = await client.get(
        Uri.parse('${getBaseUrl()}/GetScoresSorted'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          scores = jsonDecode(response.body);
        });
      } else {
        debugPrint('Failed to load scores: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching scores: $e');
    } finally {
      client.close();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text('Score List'))),
      body: ListView.builder(
        itemCount: scores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Center(
              child: Text('Name: ${scores[index]['user']['userName']}'),
            ),
            subtitle: Column(
              children: [
                Text('Value: ${scores[index]['scoreResult']}'),
                Text('Date: ${scores[index]['dateCreated']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
