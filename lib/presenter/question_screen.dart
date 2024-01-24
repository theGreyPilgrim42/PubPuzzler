import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_puzzler/domain/entities/question.dart';
import 'package:pub_puzzler/infra/services/game_provider.dart';
import 'package:pub_puzzler/presenter/question_card.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({
    super.key,
    required this.category,
    required this.difficulty,
  });

  final Category category;
  final Difficulty difficulty;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Score: ${game.score}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            QuestionCard(gameProvider: game, category: widget.category, difficulty: widget.difficulty),
          ],
        ),
      )
    );
  }
}
