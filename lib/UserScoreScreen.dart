import 'package:flutter/material.dart';
import 'EndpointHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GlobalScoreScreen.dart';

class UserScoreScreen extends StatefulWidget {
  const UserScoreScreen({super.key});

  @override
  _UserScoreScreenState createState() => _UserScoreScreenState();
}

class _UserScoreScreenState extends State<UserScoreScreen> {
  List<dynamic> scores = [];

  final EndpointHandler _endpointHandler = EndpointHandler();

  Future<void> fetchUserScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final fetchedUserScores = await _endpointHandler.fetchUserScores(userId!);
      setState(() {
        scores = fetchedUserScores;
        print('Fetched scores: $scores');
      });
    } catch (e) {
      debugPrint('Error fetching scores: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text('User Score List'))),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const GlobalScoreScreen(),
                ),
              );
            },
            child: const Text('Global Scores'),
          ),
          Expanded(
            child: ListView.builder(
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
          )
        ],
      )
    );
  }
}