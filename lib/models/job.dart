class Job {
  final int id;
  final String jobTitle;
  final String jobDescription;
  final String skills;
  final String specialisms;
  final String jobType;
  final String offeredSalary;
  final String experience;
  final String typeOfQualification;
  final String country;
  final String postedDate;
  final String closeDate;
  final String status;
  final int companyId;
  final String creatorUid;
  final String createdAt;
  final String updatedAt;
  final int archived;
  final double pt1;
  final double pt2;
  final int maxOccurrence;

  Job({
    required this.id,
    required this.jobTitle,
    required this.jobDescription,
    required this.skills,
    required this.specialisms,
    required this.jobType,
    required this.offeredSalary,
    required this.experience,
    required this.typeOfQualification,
    required this.country,
    required this.postedDate,
    required this.closeDate,
    required this.status,
    required this.companyId,
    required this.creatorUid,
    required this.createdAt,
    required this.updatedAt,
    required this.archived,
    required this.pt1,
    required this.pt2,
    required this.maxOccurrence,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? 0,
      jobTitle: json['JobTitle'] ?? '',
      jobDescription: json['JobDescription'] ?? '',
      skills: json['skills'] ?? '',
      specialisms: json['Specialisms'] ?? '',
      jobType: json['JobType'] ?? '',
      offeredSalary: json['OfferedSalary'] ?? '',
      experience: json['Experience'] ?? '',
      typeOfQualification: json['TypeOfQualification'] ?? '',
      country: json['Country'] ?? '',
      postedDate: json['PostedDate'] ?? '',
      closeDate: json['CloseDate'] ?? '',
      status: json['Status'] ?? '',
      companyId: json['companyid'] ?? 0,
      creatorUid: json['creator_uid'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      archived: json['archived'] ?? 0,
      pt1: json['PT1']?.toDouble() ?? 0.0,
      pt2: json['PT2']?.toDouble() ?? 0.0,
      maxOccurrence: json['maxOccurrence'] ?? 0,
    );
  }
}
