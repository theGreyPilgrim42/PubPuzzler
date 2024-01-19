import 'package:flutter/material.dart';

class AnswerTile extends StatelessWidget {
  const AnswerTile({
    super.key,
    required this.answerText,
    required this.checkAnswer,
    required this.answered,
    required this.correctAnswer,
  });

  final Function(String answer) checkAnswer;
  final String answerText;
  final bool answered;
  final String correctAnswer;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.95,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(2),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: answered && answerText == correctAnswer ? Theme.of(context).primaryColor : answered && answerText != correctAnswer ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary,
          side: answered && answerText == correctAnswer ? BorderSide(color: Theme.of(context).primaryColor) : answered && answerText != correctAnswer ? BorderSide(color: Theme.of(context).colorScheme.error) : BorderSide(color: Theme.of(context).colorScheme.secondary)
        ),
        onPressed: answered ? null : () => checkAnswer(answerText),
        child: Text(answerText),
      )
    );
  }
}
