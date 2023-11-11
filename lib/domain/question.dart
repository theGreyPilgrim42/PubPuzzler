import 'package:flutter/material.dart';

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

class Question {
  Category category;
  String _type;
  Difficulty difficulty;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  Question(
    this.category,
    this.difficulty,
    this.question,
    this.correctAnswer,
    this.incorrectAnswers
  ):
    _type = 'Multiple Choice';

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      Category.fromString(json['category']),
      Difficulty.values.byName(json['difficulty']),
      json['question'] as String,
      json['correct_answer'] as String,
      (json['incorrect_answers'] as List).map((item) => item as String).toList()
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