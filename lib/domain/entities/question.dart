import 'dart:math';

import 'package:html_unescape/html_unescape.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';

final unescape = HtmlUnescape(); // Used to escape HTML code types
final Random _random = Random(); // Used to get a random category
final logger = getLogger();

enum Category {
  generalKnowledge(name: 'General Knowledge', id: 9),
  entertainmentBooks(name: 'Entertainment: Books', id: 10),
  entertainmentFilm(name: 'Entertainment: Film', id: 11),
  entertainmentMusic(name: 'Entertainment: Music', id: 12),
  entertainmentMusicalsTheatres(name: 'Entertainment: Musicals & Theatres', id: 13),
  entertainmentTelevision(name: 'Entertainment: Television', id: 14),
  entertainmentVideoGames(name: 'Entertainment: Video Games', id: 15),
  entertainmentBoardGames(name: 'Entertainment: Board Games', id: 16),
  scienceNature(name: 'Science & Nature', id: 17),
  scienceComputers(name: 'Science: Computers', id: 18),
  scienceMathematics(name: 'Science: Mathematics', id: 19),
  mythology(name: 'Mythology', id: 20),
  sports(name: 'Sports', id: 21),
  geography(name: 'Geography', id: 22),
  history(name: 'History', id: 23),
  politics(name: 'Politics', id: 24),
  art(name: 'Art', id: 25),
  celebrities(name: 'Celebrities', id: 26),
  animals(name: 'Animals', id: 27),
  vehicles(name: 'Vehicles', id: 28),
  entertainmentComics(name: 'Entertainment: Comics', id: 29),
  scienceGadgets(name: 'Science: Gadgets', id: 30),
  entertainmentJapaneseAnimeManga(name: 'Entertainment: Japanese Anime & Manga', id: 31),
  entertainmentCartoonAnimations(name: 'Entertainment: Cartoon & Animations', id: 32);

  const Category({required this.name, required this.id});
  final String name;
  final int id;

   // Static parser method using random Category as fallback
  static Category fromString(String label) {
    return values.firstWhere(
      (v) => v.name == label,
      orElse: () => values[_random.nextInt(values.length)],
    );
  }
}

enum Difficulty {
  easy(name: 'Easy', id: 'easy'),
  medium(name: 'Medium', id: 'medium'),
  hard(name: 'Hard', id: 'hard');

  const Difficulty({required this.name, required this.id});
  final String name;
  final String id;

     // Static parser method using medium as fallback
  static Difficulty fromString(String label) {
    return values.firstWhere(
      (v) => v.name == label,
      orElse: () => Difficulty.medium,
    );
  }
}

enum AnswerState {
  correct,
  incorrect,
  none,
}

class Question {
  int id;
  Category category;
  String type;
  Difficulty difficulty;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;
  List<String> answers;
  AnswerState answerState;

  Question(
    this.category,
    this.type,
    this.difficulty,
    this.question,
    this.correctAnswer,
    this.incorrectAnswers
  ):
    id = 0,
    answers = [correctAnswer, ...incorrectAnswers],
    answerState = AnswerState.none {
      answers.shuffle();
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    logger.d('Creating Question from JSON...');
    return Question(
      Category.fromString(unescape.convert(json['category'])),
      unescape.convert(json['type']),
      Difficulty.values.byName(unescape.convert(json['difficulty'])),
      unescape.convert(json['question']),
      unescape.convert(json['correct_answer']),
      (json['incorrect_answers'] as List).map((item) => unescape.convert(item)).toList()
    );
  }

  @override
  String toString() {
    return "Question: $question\t"
      "Category: ${category.name}\t"
      "Difficulty: ${difficulty.name}\t"
      "Correct Answer: $correctAnswer\t"
      "Incorrect Answers: $incorrectAnswers\t";
  }
}