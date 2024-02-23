import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:pub_puzzler/domain/entities/question.dart';
import 'package:pub_puzzler/external/datasources/functions.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final String apiURL = GlobalConfiguration().getValue('baseOpenDbApiUrl');
const String questionType = '&type=multiple';
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
    Question question =
        Question.fromJson(jsonDecode(response.body)['results'][0]);
    logger.i('Successfully fetched new Question: ${question.question}');
    return question;
  } else {
    const errorMsg = 'Failed to fetch question';
    logger.e(errorMsg);
    executeLogErrorFunction(errorMsg);
    return Future.error('Failed to fetch question');
  }
}

Future<List<Question>> fetchQuestions(int amount,
    {int? category, String? difficulty}) async {
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
    List<Question> questions = (jsonDecode(response.body)['results'] as List)
        .map((item) => Question.fromJson(item))
        .toList();
    logger.i('Successfully fetched ${questions.length} new Questions');
    return questions;
  } else {
    final errorMsg = 'Failed to fetch $amount questions';
    logger.e(errorMsg);
    executeLogErrorFunction(errorMsg);
    return Future.error('Failed to fetch $amount questions');
  }
}
