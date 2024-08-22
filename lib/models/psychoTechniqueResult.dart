import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int timeInSeconds;
  final Map<String, int> categoryCorrectCounts;

  const ReportPage({
    required this.score,
    required this.totalQuestions,
    required this.timeInSeconds,
    required this.categoryCorrectCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score: $score'),
            Text('Total Questions: $totalQuestions'),
            Text('Time Taken: ${timeInSeconds ~/ 60} minutes ${timeInSeconds % 60} seconds'),
            SizedBox(height: 20),
            Text('Category Results:'),
            ...categoryCorrectCounts.entries.map((entry) {
              return Text('${entry.key}: ${entry.value}');
            }).toList(),
          ],
        ),
      ),
    );
  }
}
