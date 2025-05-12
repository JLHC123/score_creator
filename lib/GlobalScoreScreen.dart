import 'package:flutter/material.dart';
import 'EndpointHandler.dart';

class GlobalScoreScreen extends StatefulWidget {
  const GlobalScoreScreen({super.key});

  @override
  _GlobalScoreScreenState createState() => _GlobalScoreScreenState();
}

class _GlobalScoreScreenState extends State<GlobalScoreScreen> {
  List<dynamic> scores = [];

  final EndpointHandler _endpointHandler = EndpointHandler();

  Future<void> fetchScores() async {
    try {
      final fetchedScores = await _endpointHandler.fetchScores();
      setState(() {
        scores = fetchedScores;
        print('Fetched scores: $scores');
      });
    } catch (e) {
      debugPrint('Error fetching scores: $e');
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