import 'package:flutter/foundation.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final logger = getLogger();

class GameProvider extends ChangeNotifier {
  int _score = 0;

  void updateScore() {
    _score += 10;
    logger.i('Updated score to $_score');
    notifyListeners();
  }

  int get score => _score;
}
