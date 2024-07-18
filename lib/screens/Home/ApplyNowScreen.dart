import 'package:flutter/material.dart';
import 'PersonalityTest.dart'; 

class ApplyNowScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply Now'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 100,
                        color: Colors.grey[200],
                        child: Text(
                          '①',
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Personality Test',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 30,
                  child: Center(
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 2,
                      width: 20,
                      indent: 10,
                      endIndent: 10,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 100,
                        color: Colors.grey[200],
                        child: Text(
                          '②',
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Psycho-Technical Test',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to the PersonalityTest screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalityTest()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Dark purple color
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Pass the test',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
