import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_puzzler/domain/entities/question_entity.dart';
import 'package:pub_puzzler/infra/services/game_provider.dart';
import 'package:pub_puzzler/infra/services/question_provider.dart';
import 'package:pub_puzzler/presenter/widgets/question_card_widget.dart';

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
    return Consumer2<GameProvider, QuestionProvider>(
        builder: (context, game, question, child) => Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Score: ${game.currentGame.score}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  QuestionCard(
                      gameProvider: game,
                      questionProvider: question,
                      category: widget.category,
                      difficulty: widget.difficulty),
                ],
              ),
            ));
  }
}
