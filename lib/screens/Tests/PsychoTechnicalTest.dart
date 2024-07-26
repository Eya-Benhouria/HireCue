import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hirecue_app/models/psychoTechniqueResult.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';

class TestPsychotechniqueCandidat extends StatefulWidget {
  final int testId;

  const TestPsychotechniqueCandidat({required this.testId});

  @override
  _TestPsychotechniqueCandidatState createState() =>
      _TestPsychotechniqueCandidatState();
}

class _TestPsychotechniqueCandidatState
    extends State<TestPsychotechniqueCandidat> {
  late int localTime;
  late int timePerQuestionPsycho;
  int timeInSeconds = 0;
  List<dynamic> categories = [];
  ValueNotifier<int> currentIndexCategory = ValueNotifier(0);
  Map<String, dynamic> testDetails = {};
  Map<int, String> selectedAnswers = {};
  Map<int, Map<String, String>> result = {};
  int score = 0;
  bool submitClicked = false;
  bool timerExpired = false;
  bool isButtonDisabled = false;
  Map<String, int> categoryCorrectCounts = {};
  Timer? timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  String lang = 'en'; // Default language
  int nbrQuesPerCat = 0;

  @override
  void initState() {
    super.initState();
    initializeSettings();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> initializeSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Initialize or reset state variables
      localTime = prefs.getInt('questionsNbrPsycho') ?? 10;
      timePerQuestionPsycho = prefs.getInt('timePerQuestionPsycho') ?? 30;
      testDetails = {};
      categories = [];
      currentIndexCategory.value = 0;
      timeInSeconds = 0;
      selectedAnswers.clear(); // Clear previous answers
      result.clear(); // Clear previous results
      score = 0;
      submitClicked = false;
      timerExpired = false;
      isButtonDisabled = false;
      categoryCorrectCounts.clear();
    });

    fetchTestDetails(widget.testId.toString());
  }

  Future<void> fetchTestDetails(String testId) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${Config.appDomain}/api/testPsycho/getTestWithQuestionsById/$testId'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['categories'] is List) {
          var totalQuestions = (jsonResponse['categories'] as List)
              .expand((category) => category['questions'] as List)
              .length;
          nbrQuesPerCat =
              totalQuestions ~/ (jsonResponse['categories'] as List).length;
          setState(() {
            testDetails = jsonResponse;
            categories = (jsonResponse['categories'] as List)
                .map((category) => category['category_name'])
                .toList();

            // Ensure currentIndexCategory is within bounds
            if (categories.isNotEmpty) {
              currentIndexCategory.value =
                  currentIndexCategory.value >= categories.length
                      ? categories.length - 1
                      : currentIndexCategory.value;
            } else {
              currentIndexCategory.value = -1; // Or any other invalid value
            }

            int totalQuestions = 0;
            for (var category in jsonResponse['categories']) {
              if (category['questions'] is List) {
                totalQuestions += (category['questions'] as List).length;
              }
            }

            timeInSeconds = totalQuestions * timePerQuestionPsycho;
            startTimer();
          });
        } else {
          print('Invalid data format: ${response.body}');
        }
      } else {
        print('Error fetching test details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching test details: $error');
    }
  }

  void changeTest(String newTestId) {
    // Reset state before fetching new test details
    setState(() {
      testDetails = {}; // or null
      categories = [];
      currentIndexCategory.value = 0; // Reset or set to a safe default
      timeInSeconds = 0;
    });

    // Fetch new test details
    fetchTestDetails(newTestId);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (timeInSeconds > 0) {
        setState(() {
          timeInSeconds--;
          hours = timeInSeconds ~/ 3600;
          minutes = (timeInSeconds % 3600) ~/ 60;
          seconds = timeInSeconds % 60;
        });
      } else {
        handleSubmitTest();
        timer.cancel();
      }
    });
  }

  Widget renderContent(String content, int questionId, String categoryName) {
    var imageUrl = getImageUrl(content, questionId, categoryName);
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return Image.network(
          imageUrl,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        );
      } else {
        return Image.file(
          File(imageUrl),
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        );
      }
    } else {
      return Text(content);
    }
  }

  String? getImageUrl(String imageRef, int id, String categoryName) {
    if (isImage(imageRef)) {
      return '${Config.appDomain}/api/question1/images/$categoryName/$id/$imageRef';
    }
    return null;
  }

  bool isImage(String content) {
    final imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif'
    ]; // Add more extensions as needed
    return imageExtensions.any((ext) => content.toLowerCase().endsWith(ext));
  }

  Future<String> getUserCompanyID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userCompanyId') ?? 'default_company_id';
  }

  void getTheNextValue() {
    setState(() {
      if (currentIndexCategory.value < categories.length - 1) {
        currentIndexCategory.value++;
        selectedAnswers
            .clear(); // Clear answers when moving to the next category
      }
    });
  }

  void getPreviousValue() {
    setState(() {
      if (currentIndexCategory.value > 0) {
        currentIndexCategory.value--;
        selectedAnswers
            .clear(); // Clear answers when moving to the previous category
      }
    });
  }

  void handleAnswerChange(int questionId, String answer) {
    setState(() {
      selectedAnswers[questionId] = answer;
    });
  }

  void handleSubmitTest() {
    Map<int, Map<String, String>> newResult = {};
    var newScore = 0;
    var catList = <String>[];
    var catListEr = <String>[];
    (testDetails['categories'] as List).forEach((category) {
      (category['questions'] as List).forEach((question) {
        var questionId = question['id'];
        var selectedAnswer = selectedAnswers[questionId];
        var correctAnswer = question['BonneReponse'];

        newResult[questionId] = {
          'selectedAnswer': selectedAnswer ?? '',
          'correctAnswer': correctAnswer,
        };

        if (selectedAnswer == correctAnswer) {
          newScore++;
          catList.add(category['category_name']);
        } else {
          catListEr.add(category['category_name']);
        }
      });
    });

    var comptages = <String, int>{};
    catList.forEach((cat) {
      comptages[cat] = (comptages[cat] ?? 0) + 1;
    });

    var comptagesEr = <String, int>{};
    catListEr.forEach((cat) {
      comptagesEr[cat] = (comptagesEr[cat] ?? 0);
    });

    var liste = <String, int>{};
    comptages.forEach((cat, count) {
      liste[cat] = count + (comptagesEr[cat] ?? 0);
    });

    comptagesEr.forEach((cat, count) {
      if (liste[cat] == null) {
        liste[cat] = count;
      }
    });

    setState(() {
      result = newResult;
      score = newScore;
      submitClicked = true;
      isButtonDisabled = true;
      categoryCorrectCounts = liste;
    });

    updateScoreInDatabase(newScore, liste, timeInSeconds, nbrQuesPerCat);
    updateScore(newScore, timeInSeconds, nbrQuesPerCat);
    redirectToRapport(timeInSeconds, liste, nbrQuesPerCat);
  }

  Future<void> updateScoreInDatabase(
      int score,
      Map<String, int> categoryCorrectCounts,
      int timeInSeconds,
      int nbrQuesPerCat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDetailsString = prefs.getString('userDetails');
    var jobRoleId = prefs.getString('jobRoleId');

    if (userDetailsString != null && jobRoleId != null) {
      var userDetails = jsonDecode(userDetailsString);
      var selectedCandidate = userDetails['localId'];
      var radarPsychoJSON = jsonEncode(categoryCorrectCounts);
      var score1 = nbrQuesPerCat * score;
      var scorePerTime = score1 / timeInSeconds;
      var scoreFin10 = (10 * scorePerTime) / nbrQuesPerCat;

      try {
        await http.put(
            Uri.parse(
                '${Config.appDomain}/api/jobrole/candidatesjobtest/$selectedCandidate/$jobRoleId/${widget.testId}'),
            body: jsonEncode({
              'note': scoreFin10,
              'radarPsycho': radarPsychoJSON,
              'time': timeInSeconds,
            }),
            headers: {'Content-Type': 'application/json'});
      } catch (error) {
        print('Error updating score in database: $error');
      }
    }
  }

  void updateScore(int score, int timeInSeconds, int nbrQuesPerCat) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('lastScore', score);
      prefs.setInt('totalQuestions', nbrQuesPerCat);
      prefs.setInt('timeInSeconds', timeInSeconds);
    });
  }

  void redirectToRapport(int timeInSeconds,
      Map<String, int> categoryCorrectCounts, int nbrQuesPerCat) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReportPage(
          score: score,
          totalQuestions: nbrQuesPerCat,
          timeInSeconds: timeInSeconds,
          categoryCorrectCounts: categoryCorrectCounts,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Test Psychotechnique'),
            Spacer(),
            Text(
              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: testDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (categories.isNotEmpty &&
                              currentIndexCategory.value >= 0 &&
                              currentIndexCategory.value < categories.length)
                            Text(testDetails['categories']
                                [currentIndexCategory.value]['category_name']),
                          Text(testDetails['test_name']),
                          Expanded(
                            child: categories.isNotEmpty &&
                                    currentIndexCategory.value >= 0 &&
                                    currentIndexCategory.value <
                                        categories.length
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: testDetails.isNotEmpty &&
                                            currentIndexCategory.value >= 0 &&
                                            currentIndexCategory.value <
                                                (testDetails['categories']
                                                        as List)
                                                    .length
                                        ? (testDetails['categories']
                                                    [currentIndexCategory.value]
                                                ['questions'] as List)
                                            .length
                                        : 0,
                                    itemBuilder: (context, index) {
                                      var currentCategory =
                                          testDetails['categories']
                                              [currentIndexCategory.value];
                                      if (index < 0 ||
                                          index >=
                                              currentCategory['questions']
                                                  .length) {
                                        return SizedBox.shrink();
                                      }
                                      var currentQuestion =
                                          currentCategory['questions'][index];

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${index + 1}. ${currentQuestion['question'] ?? "Question not found"}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          if (currentQuestion['imageRef'] !=
                                              null)
                                            Container(
                                              height: 200,
                                              child: renderContent(
                                                  currentQuestion['imageRef'],
                                                  currentQuestion['id'],
                                                  currentCategory[
                                                      'category_name']),
                                            ),
                                          Column(
                                            children: [
                                              RadioListTile(
                                                title: currentQuestion[
                                                                'choix1'] !=
                                                            null &&
                                                        isImage(currentQuestion[
                                                            'choix1'])
                                                    ? renderContent(
                                                        currentQuestion[
                                                            'choix1'],
                                                        currentQuestion['id'],
                                                        currentCategory[
                                                            'category_name'])
                                                    : Text(currentQuestion[
                                                            'choix1'] ??
                                                        ''),
                                                value: 'choix1',
                                                groupValue: selectedAnswers[
                                                    currentQuestion['id']],
                                                onChanged: (value) {
                                                  handleAnswerChange(
                                                      currentQuestion['id'],
                                                      value.toString());
                                                },
                                              ),
                                              RadioListTile(
                                                title: currentQuestion[
                                                                'choix2'] !=
                                                            null &&
                                                        isImage(currentQuestion[
                                                            'choix2'])
                                                    ? renderContent(
                                                        currentQuestion[
                                                            'choix2'],
                                                        currentQuestion['id'],
                                                        currentCategory[
                                                            'category_name'])
                                                    : Text(currentQuestion[
                                                            'choix2'] ??
                                                        ''),
                                                value: 'choix2',
                                                groupValue: selectedAnswers[
                                                    currentQuestion['id']],
                                                onChanged: (value) {
                                                  handleAnswerChange(
                                                      currentQuestion['id'],
                                                      value.toString());
                                                },
                                              ),
                                              RadioListTile(
                                                title: currentQuestion[
                                                                'choix3'] !=
                                                            null &&
                                                        isImage(currentQuestion[
                                                            'choix3'])
                                                    ? renderContent(
                                                        currentQuestion[
                                                            'choix3'],
                                                        currentQuestion['id'],
                                                        currentCategory[
                                                            'category_name'])
                                                    : Text(currentQuestion[
                                                            'choix2'] ??
                                                        ''),
                                                value: 'choix3',
                                                groupValue: selectedAnswers[
                                                    currentQuestion['id']],
                                                onChanged: (value) {
                                                  handleAnswerChange(
                                                      currentQuestion['id'],
                                                      value.toString());
                                                },
                                              ),
                                              RadioListTile(
                                                title: currentQuestion[
                                                                'choix4'] !=
                                                            null &&
                                                        isImage(currentQuestion[
                                                            'choix4'])
                                                    ? renderContent(
                                                        currentQuestion[
                                                            'choix4'],
                                                        currentQuestion['id'],
                                                        currentCategory[
                                                            'category_name'])
                                                    : Text(currentQuestion[
                                                            'choix3'] ??
                                                        ''),
                                                value: 'choix4',
                                                groupValue: selectedAnswers[
                                                    currentQuestion['id']],
                                                onChanged: (value) {
                                                  handleAnswerChange(
                                                      currentQuestion['id'],
                                                      value.toString());
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : SizedBox.shrink(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: categories.isEmpty ||
                                        currentIndexCategory.value <= 0
                                    ? null
                                    : getPreviousValue,
                                child: Text(
                                    lang == 'en' ? 'Previous' : 'Précédent'),
                              ),
                              ElevatedButton(
                                onPressed: submitClicked
                                    ? null
                                    : currentIndexCategory.value ==
                                            categories.length - 1
                                        ? handleSubmitTest
                                        : getTheNextValue,
                                child: Text(currentIndexCategory.value ==
                                        categories.length - 1
                                    ? lang == 'en'
                                        ? 'Submit'
                                        : 'Soumettre'
                                    : lang == 'en'
                                        ? 'Next'
                                        : 'Suivant'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearPercentIndicator(
                    lineHeight: 20.0,
                    percent: categories.isEmpty ||
                            testDetails['categories'].length == 0
                        ? 0
                        : (currentIndexCategory.value + 1) /
                            testDetails['categories'].length,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.green,
                    center: Text(
                      "${((currentIndexCategory.value + 1) / testDetails['categories'].length * 100).toStringAsFixed(1)}%",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
