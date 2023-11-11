import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pub_puzzler/domain/question.dart';

Future<Question> fetchQuestion() async {
  final response = await http.get(Uri.parse('https://opentdb.com/api.php?amount=1'));
  if (response.statusCode == 200) {
    return Question.fromJson(jsonDecode(response.body)['results'][0]);
  } else {
    throw Exception('Failed to load question');
  }
}