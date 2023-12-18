import 'package:html_unescape/html_unescape.dart';

// Used to escape HTML code types
final unescape = HtmlUnescape();

enum Category<T extends Object> {
  generalKnowledge<String>('General Knowledge'),
  entertainmentBooks<String>('Entertainment: Books'),
  entertainmentFilm<String>('Entertainment: Film'),
  entertainmentMusic<String>('Entertainment: Music'),
  entertainmentMusicalsTheatres<String>('Entertainment: Musicals & Theatres'),
  entertainmentTelevision<String>('Entertainment: Television'),
  entertainmentVideoGames<String>('Entertainment: Video Games'),
  entertainmentBoardGames<String>('Entertainment: Board Games'),
  scienceNature<String>('Science & Nature'),
  scienceComputers<String>('Science: Computers'),
  scienceMathematics<String>('Science: Mathematics'),
  mythology<String>('Mythology'),
  sports<String>('Sports'),
  geography<String>('Geography'),
  history<String>('History'),
  politics<String>('Politics'),
  art<String>('Art'),
  celebrities<String>('Celebrities'),
  animals<String>('Animals'),
  vehicles<String>('Vehicles'),
  entertainmentComics<String>('Entertainment: Comics'),
  scienceGadgets<String>('Science: Gadgets'),
  entertainmentJapaneseAnimeManga<String>('Entertainment: Japanese Anime & Manga'),
  entertainmentCartoonAnimations<String>('Entertainment: Cartoon & Animations'),
  random<String>('Random');

  const Category(this.name);
  final T name;

   // Static parser method using random as fallback
  static Category fromString(String label) {
    return values.firstWhere(
      (v) => v.name == label,
      orElse: () => Category.random,
    );
  }
}

enum Difficulty<T extends Object> {
  easy<String>('Easy'),
  medium<String>('Medium'),
  hard<String>('Hard');

  const Difficulty(this.name);
  final T name;

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
    answers = [correctAnswer, ...incorrectAnswers],
    answerState = AnswerState.none {
      answers.shuffle();
  }

  factory Question.fromJson(Map<String, dynamic> json) {
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