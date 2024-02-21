import 'package:flutter/foundation.dart';
import 'package:pub_puzzler/domain/entities/game.dart';
import 'package:pub_puzzler/external/datasources/database.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final logger = getLogger();

class GameProvider extends ChangeNotifier {
  final Set<Game> _games = <Game>{};
  bool _isUpdated = false;
  int _totalScore = 0;
  double _accuracy = 0.0;
  final int _maxRounds = 5;

  Future<void> getGames(String userId) async {
    if (_isUpdated) return;
    logger.d("Getting played games from backend...");
    List<Game> newGames = await getGame(userId);
    _games.addAll(newGames);
    _isUpdated = true;
    _calculateScore();
    _calculateAccuracy();
    notifyListeners();
  }

  void addNewGame(String userId) {
    logger.d("Adding a new game...");
    _games.add(Game(userId));
    notifyListeners();
  }

  void updateCurrentGame(bool questionState, bool increaseScore) {
    Game current = _games.last;
    current.addQuestion(questionState);
    if (increaseScore) {
      current.updateScore();
    }
    logger.d("Updated the current game - Question: $questionState | score: ${current.score}");
    notifyListeners();
  }

  Future<void> persistCurrentGame() async {
    logger.d("Persisting the current game in the backend...");
    Game current = _games.last;
    _calculateScore();
    _calculateAccuracy();
    await addGame(current.userId, current.score, current.questions);
    notifyListeners();
  }

  // Check if the following two methods should be used as cloud functions on appwrite to include something more in the app
  void _calculateScore() {
    int total = 0;
    for (final game in _games) {
      total += game.score;
    }
    _totalScore = total;
    notifyListeners();
  }

  void _calculateAccuracy() {
    int totalQuestions = 0;
    int correctlyAnsweredQuestions = 0;
    for (final game in _games) {
      totalQuestions += game.questions.length;
      correctlyAnsweredQuestions += game.questions.where((element) => element).length;
    }
    _accuracy = (correctlyAnsweredQuestions / totalQuestions) * 100.0;
    notifyListeners();
  }

  Set<Game> get games => _games;
  Game get currentGame => _games.last;
  int get totalScore => _totalScore;
  double get accuracy => _accuracy;
  int get maxRounds => _maxRounds;
}