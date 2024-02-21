import 'package:appwrite/models.dart';

class Game {
  final String _userId;
  int _score;
  final List<bool> _questions;

  Game(this._userId)
      : _score = 0,
        _questions = [];

  Game.fromDoc(Document document)
      : _userId = document.data["userId"],
        _score = document.data["score"],
        _questions = List<bool>.from(
                document.data["questions"].map((question) => question as bool))
            .toList();

  String get userId => _userId;
  int get score => _score;
  List<bool> get questions => _questions;

  void updateScore() {
    _score += 10;
  }

  void addQuestion(bool state) {
    _questions.add(state);
  }

  @override
  String toString() {
    return "Game - userId: $_userId, score: $_score, questions: ${_questions.toString()}";
  }
}
