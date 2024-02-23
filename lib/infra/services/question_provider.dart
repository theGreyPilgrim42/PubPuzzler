import 'package:flutter/foundation.dart';
import 'package:pub_puzzler/domain/entities/question_entity.dart';
import 'package:pub_puzzler/external/datasources/question_datasource.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final _logger = getLogger();

class QuestionProvider extends ChangeNotifier {
  int _nextId = 1;
  final List<Question> _questions = [];
  
  Future<Question> getNewQuestion({int? category, String? difficulty}) async {
    try {
      Question question = await fetchQuestion(category: category, difficulty: difficulty);
      if (_isExisting(question)) {
        return getNewQuestion(category: category, difficulty: difficulty);
      }
      question.id = _nextId++;
      _questions.add(question);
      return question;
    } catch(e) {
      _logger.e('An error occurred while getting a new question - $e');
      throw Future.error('An error occurred while getting a new question');
    }
    
  }

  bool _isExisting(Question question) {
    List<String> currentQuestions = _questions.map((q) => q.question).toList();
    if (currentQuestions.contains(question.question)) {
      return true;
    }
    return false;
  }
}