import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hirecue_app/GlobalComponents/color_config.dart';
import 'package:hirecue_app/screens/Tests/PersonalityTest.dart';
import 'package:hirecue_app/screens/Tests/PsychoTechnicalTest.dart';
import '../../models/job.dart';

class ApplyNowScreen extends StatefulWidget {
  final Job job;

  const ApplyNowScreen({required this.job});

  @override
  _ApplyNowScreenState createState() => _ApplyNowScreenState();
}

class _ApplyNowScreenState extends State<ApplyNowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Apply Now',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorConfig.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorConfig.primaryColor, ColorConfig.secondColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          // Center the content vertically and horizontally
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildStepCircle("1", Icons.psychology_outlined),
                    buildStepArrow(),
                    buildStepCircle("2", Icons.assessment_outlined),
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'Choose the test to start with',
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalityTest(
                          testId: widget.job.id,
                          job: widget.job,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: ColorConfig.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                    textStyle: TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Start Personality Test',
                    style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TestPsychotechniqueCandidat(testId: widget.job.id),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: ColorConfig.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                    textStyle: TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Start Psycho-Technical Test',
                    style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStepCircle(String number, IconData icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Icon(
          icon,
          color: ColorConfig.primaryColor,
          size: 24,
        ),
      ),
    );
  }

  Widget buildStepArrow() {
    return Container(
      width: 30,
      child: Center(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white54,
        ),
      ),
    );
  }
}
