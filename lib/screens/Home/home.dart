import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hirecue_app/screens/Authentication/sign_in.dart';
import 'package:hirecue_app/screens/Home/JobDetailsScreen.dart';

import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../../GlobalComponents/color_config.dart';
import '../../models/job.dart';
import '../../services/auth_service.dart'; // Import AuthService

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Job> jobs = [];
  final AuthService _authService = AuthService(); // Instantiate AuthService

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('jwt_token'); // Retrieve token from SharedPreferences

    if (token != null) {
      print('Token used for API call: $token');
      print('Token length api: ${token.length}');
      final response = await http.get(
        Uri.parse('http://212.132.108.203/api/jobrole/getAll'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Process response
        setState(() {
          jobs = parseJobs(
              response.body); // Ensure you have a method to parse jobs
        });
      } else {
        print('Failed to fetch jobs: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      print('No token found');
    }
  }

  List<Job> parseJobs(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Job>((json) => Job.fromJson(json)).toList();
  }

  Future<void> _handleLogout() async {
    try {
      await _authService.googleSignout();
      // Navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              height: 50,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return JobCard(job: jobs[index]);
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_added_outlined),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorConfig.secondColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _handleLogout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Job Title
            Text(
              job.jobTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 8),

            // Offered Salary
            Row(
              children: <Widget>[
                Icon(Icons.monetization_on, size: 16),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    job.offeredSalary,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Experience
            Row(
              children: <Widget>[
                Icon(Icons.work, size: 16),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    job.experience,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Job Type
            Row(
              children: <Widget>[
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    job.jobType,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Posted Date
            Row(
              children: <Widget>[
                Icon(Icons.access_time, size: 16),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Posted: ${job.postedDate.substring(0, 10)}',
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Close Date
            Row(
              children: <Widget>[
                Icon(Icons.access_time, size: 16),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Close: ${job.closeDate.substring(0, 10)}',
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // View Details Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => JobDetailsDialog(job: job),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: ColorConfig.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
