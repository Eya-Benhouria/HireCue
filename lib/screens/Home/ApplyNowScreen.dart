import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hirecue_app/GlobalComponents/color_config.dart';

import 'package:hirecue_app/screens/Tests/PersonalityTest.dart';



class ApplyNowScreen extends StatefulWidget {
  @override
  _ApplyNowScreenState createState() => _ApplyNowScreenState();
}

class _ApplyNowScreenState extends State<ApplyNowScreen>
    with SingleTickerProviderStateMixin {
  bool _isButtonPressed = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                    buildStepCircle(
                        "1", Icons.psychology_outlined, _isButtonPressed),
                    buildStepArrow(),
                    buildStepCircle("2", Icons.assessment_outlined, false),
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'Personality Test',
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Followed by Psycho-Technical Test',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isButtonPressed = true; // Start the animation
                      _controller.forward();
                    });

                    Future.delayed(Duration(milliseconds: 500), () {
                      // Delay navigation
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonalityTest()),
                      );
                    });
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
                    'Get Started',
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

  Widget buildStepCircle(String number, IconData icon, bool isAnimated) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isAnimated ? Colors.white : Colors.grey[300],
      ),
      child: Center(
        child: Icon(
          icon,
          color: isAnimated ? ColorConfig.primaryColor : Colors.black,
          size: isAnimated ? _animation.value * 36 : 24, // Animated size
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
