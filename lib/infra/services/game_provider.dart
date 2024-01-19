import 'package:flutter/foundation.dart';

class GameProvider extends ChangeNotifier {
  int _score = 0;

  void updateScore() {
    debugPrint('Processing updateScore..');
    _score += 10;
    notifyListeners();
  }

  int get score => _score;
}