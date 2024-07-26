import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hirecue_app/GlobalComponents/color_config.dart';
import 'package:hirecue_app/screens/Tests/PsychoTechnicalTest.dart';

import '../../models/job.dart';

class JobDetailsDialog extends StatefulWidget {
  final Job job;

  const JobDetailsDialog({required this.job});

  @override
  _JobDetailsDialogState createState() => _JobDetailsDialogState();
}

class _JobDetailsDialogState extends State<JobDetailsDialog> {
  bool showFullDescription = false;

  // Define a list of colors for skills
  final List<Color> skillColors = [
    ColorConfig.secondColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Colors.white,
      elevation: 5.0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Job Title with Stylish Design
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent
                        .withOpacity(0.1), // Light blue background
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.job.jobTitle,
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      buildDetailRow('Job Type:', widget.job.jobType),
                      buildDetailRow(
                          'Offered Salary:', widget.job.offeredSalary),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Job Details
                buildDetailSection(context, 'Job Details', [
                  // Skills as Tags
                  buildDetailRow('Skills:', ''),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.job.skills
                        .split(',')
                        .map((skill) => Chip(
                              label: Text(skill.trim()),
                              backgroundColor: _getColorForSkill(skill.trim()),
                              labelStyle: TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),

                  // Description with "View More"
                  buildDetailRow('Description:', ''),
                  GestureDetector(
                    onTap: () => setState(
                        () => showFullDescription = !showFullDescription),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Text(
                        showFullDescription
                            ? widget.job.jobDescription
                            : (widget.job.jobDescription.length > 100
                                ? widget.job.jobDescription.substring(0, 100) +
                                    '...'
                                : widget.job.jobDescription),
                        key: ValueKey(showFullDescription),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  if (!showFullDescription &&
                      widget.job.jobDescription.length > 100)
                    SizedBox(height: 8),
                ]),

                // Additional Details (optional)
                buildDetailSection(context, 'Additional Details', [
                  buildDetailRow('Specialisms:', widget.job.specialisms),
                  buildDetailRow('Experience:', widget.job.experience),
                  buildDetailRow(
                      'Qualification:', widget.job.typeOfQualification),
                  buildDetailRow('Country:', widget.job.country),
                  buildDetailRow(
                      'Posted:', widget.job.postedDate.substring(0, 10)),
                  buildDetailRow(
                      'Closes:', widget.job.closeDate.substring(0, 10)),
                ]),

                SizedBox(height: 20),

                // Apply Button
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: ColorConfig.primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestPsychotechniqueCandidat(
                              testId: widget.job.id),
                        ),
                      );
                    },
                    icon: Icon(Icons.send),
                    label: Text('Apply Now'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build detail sections
  Widget buildDetailSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        ...children,
        SizedBox(height: 16),
        Divider(color: Colors.grey[300]), // Add a divider
      ],
    );
  }

  // Helper function to create styled rows for job details
  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.lato(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForSkill(String skill) {
    int hash = skill.hashCode.abs();
    return skillColors[hash % skillColors.length];
  }
}
