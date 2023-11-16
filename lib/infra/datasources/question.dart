import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pub_puzzler/domain/question.dart';

const String apiURL = 'https://opentdb.com/api.php';
const String questionType = '&type=multiple';

Future<Question> fetchQuestion() async {
  final response = await http.get(Uri.parse('$apiURL?amount=1$questionType'));
  if (response.statusCode == 200) {
    return Question.fromJson(jsonDecode(response.body)['results'][0]);
  } else {
    throw Exception('Failed to load question');
  }
}

Future<List<Question>> fetchQuestions(int amount) async {
  final response = await http.get(Uri.parse('$apiURL?amount=$amount$questionType'));
  if (response.statusCode == 200) {
    return (jsonDecode(response.body)['results'] as List).map((item) => Question.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load questions');
  }
}