import 'package:pub_puzzler/domain/entities/question.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final logger = getLogger();

class QuestionRepository {
  int _nextId = 1;
  // ignore: prefer_final_fields
  List<Question> _questions = [];
  // Singleton approach
  static final QuestionRepository _questionRepository =
      QuestionRepository._privateConstructor();
  QuestionRepository._privateConstructor();

  factory QuestionRepository() {
    return _questionRepository;
  }

  Future<void> addQuestion(Question question) async {
    question.id = _nextId++;
    _questions.add(question);
    logger.i(
        "Added question '#${question.id} - ${question.question}' to Repository");
  }

  Future<List<Question>> getQuestions() async {
    return _questions;
  }

  Future<Question> getQuestion(int id) async {
    return _questions.firstWhere((question) => question.id == id);
  }

  Future<void> removeQuestion(int id) async {
    _questions.removeWhere((question) => question.id == id);
    logger.i("Removed question '#$id' from Repository");
  }
}
