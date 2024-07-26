import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hirecue_app/screens/Tests/JobDetailsScreen.dart';
import 'package:http/http.dart' as http;

import '../../GlobalComponents/color_config.dart';
import '../../models/job.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      var response =
          await http.get(Uri.parse('http://212.132.108.203/api/job-list'));

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        List<Job> fetchedJobs =
            responseData.map((e) => Job.fromJson(e)).toList();

        setState(() {
          jobs = fetchedJobs;
        });
      } else {
        print('Failed to load jobs');
      }
    } catch (e) {
      print('Error fetching jobs: $e');
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
