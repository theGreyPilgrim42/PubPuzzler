import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pub_puzzler/domain/entities/question.dart';
import 'package:pub_puzzler/infra/repositories/question_repository.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

const String apiURL = 'https://opentdb.com/api.php';
const String questionType = '&type=multiple';
final QuestionRepository questionRepository = QuestionRepository();
final logger = getLogger();

Future<Question> fetchQuestion({int? category, String? difficulty}) async {
  String url = '$apiURL?amount=1';
  if (category != null) {
    url = '$url&category=$category';
  }
  if (difficulty != null) {
    url = '$url&difficulty=$difficulty';
  }
  url = '$url$questionType';
  logger.d('Trying to fetch Question from URL: $url');
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    Question question = Question.fromJson(jsonDecode(response.body)['results'][0]);
    await questionRepository.addQuestion(question);
    logger.i('Successfully fetched new Question: ${question.question}');
    return question;
  } else {
    logger.e('Failed to fetch question');
    throw Exception('Failed to fetch question');
  }
}

Future<List<Question>> fetchQuestions(int amount, {int? category, String? difficulty}) async {
  String url = '$apiURL?amount=$amount';
  if (category != null) {
    url = '$url&category=$category';
  }
  if (difficulty != null) {
    url = '$url&difficulty=$difficulty';
  }
  url = '$url$questionType';
  logger.d('Trying to fetch Questions from URL: $url');
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List<Question> questions = (jsonDecode(response.body)['results'] as List).map((item) => Question.fromJson(item)).toList();
    for (final question in questions) {
      await questionRepository.addQuestion(question);
    }
    logger.i('Successfully fetched ${questions.length} new Questions');
    return questions;
  } else {
    logger.e('Failed to fetch $amount questions');
    throw Exception('Failed to fetch $amount questions');
  }
}