import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hirecue_app/GlobalComponents/color_config.dart';
import 'package:http/http.dart' as http;

class PersonalityTest extends StatefulWidget {
  @override
  _PersonalityTestState createState() => _PersonalityTestState();
}

class _PersonalityTestState extends State<PersonalityTest> {
  List<dynamic> _questions = [];
  Map<int, String?> _responses = {};
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _fetchTestQuestions();
  }

  Future<void> _fetchTestQuestions() async {
    final response = await http
        .get(Uri.parse('http://212.132.108.203/api/page-test-candidate/1'));
    if (response.statusCode == 200) {
      setState(() {
        _questions = json.decode(response.body);
      });
    } else {
      // Handle error
      print('Failed to load test questions');
    }
  }

  void _handleResponseChange(int questionIndex, String? value) {
    setState(() {
      _responses[questionIndex] = value;
      _isFormValid = _responses.length == _questions.length &&
          !_responses.values.contains(null);
    });
  }

  void _submitTest() async {
    final responsesData = _responses.map((questionIndex, response) =>
        MapEntry(questionIndex.toString(), response));

    final response = await http.post(
      Uri.parse('http://212.132.108.203/api/submit-test'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'responses': responsesData}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test Submitted Successfully')),
      );
      Navigator.pushReplacementNamed(context, '/thankYouPage');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit test')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
        backgroundColor: ColorConfig.primaryColor,
      ),
      body: _questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['question'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      ...[
                        'Totally disagree',
                        'Disagree',
                        'Neutral',
                        'Agree',
                        'Totally agree'
                      ].map((response) {
                        return ListTile(
                          title: Text(response),
                          leading: Radio<String?>(
                            value: response,
                            groupValue: _responses[index],
                            onChanged: (value) {
                              _handleResponseChange(index, value);
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isFormValid ? _submitTest : null,
          
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Dark purple color
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
