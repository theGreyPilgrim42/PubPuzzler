import 'package:flutter/material.dart';
import 'package:pub_puzzler/domain/entities/question_entity.dart';
import 'package:pub_puzzler/infra/services/game_provider.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';
import 'package:pub_puzzler/infra/services/question_provider.dart';
import 'package:pub_puzzler/presenter/widgets/answer_tile.dart';

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.gameProvider,
    required this.questionProvider,
    required this.category,
    required this.difficulty,
  });

  final GameProvider gameProvider;
  final QuestionProvider questionProvider;
  final Category category;
  final Difficulty difficulty;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with TickerProviderStateMixin {
  final logger = getLogger();
  late Future<Question> question = widget.questionProvider.getNewQuestion(
      category: widget.category.id, difficulty: widget.difficulty.id);
  late AnimationController animationController;

  bool answered = false;
  int questionNumber = 1;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => countdown());
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> checkAnswer(String answer) async {
    setState(() {
      question.then((q) {
        if (answer == q.correctAnswer) {
          q.answerState = AnswerState.correct;
          widget.gameProvider.updateCurrentGame(true, true);
        } else {
          q.answerState = AnswerState.incorrect;
          widget.gameProvider.updateCurrentGame(false, false);
        }
        logger.d('Answer is: ${q.correctAnswer}');
      });
      answered = true;
    });
  }

  Future<void> countdown() async {
    animationController.reset();
    await animationController.forward();
    if (animationController.status == AnimationStatus.completed && !answered) {
      logger.d('Question was not answered in time');
      checkAnswer("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 12.5,
        child: FutureBuilder<Question>(
          future: question,
          builder: (BuildContext context, AsyncSnapshot<Question> snapshot) {
            List<Widget> children;
            if (questionNumber > widget.gameProvider.maxRounds) {
              children = <Widget>[
                Card(
                    elevation: 12.5,
                    margin: const EdgeInsets.all(10),
                    child: Column(children: [
                      const Text("Game Finished"),
                      ElevatedButton(
                        onPressed: () {
                          widget.gameProvider.persistCurrentGame();
                          Navigator.pop(context);
                        },
                        child: const Text("Go Back"),
                      )
                    ])),
              ];
            } else if (snapshot.hasData) {
              children = <Widget>[
                Card(
                  elevation: 12.5,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.question_mark),
                        title: Center(
                          child: Text('Question #$questionNumber'),
                        ),
                        subtitle: Center(
                          child: Text(snapshot.data!.category.name.toString()),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      Column(
                        children: [
                          LinearProgressIndicator(
                            value: animationController.value,
                          ),
                          Text(
                            snapshot.data!.question,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          for (var answer in snapshot.data!.answers)
                            AnswerTile(
                              answerText: answer,
                              checkAnswer: checkAnswer,
                              answered: answered,
                              correctAnswer: snapshot.data!.correctAnswer,
                            ),
                          if (answered)
                            Text(
                              snapshot.data!.answerState == AnswerState.correct
                                  ? 'Correct!'
                                  : 'Incorrect!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: snapshot.data!.answerState ==
                                        AnswerState.correct
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).colorScheme.error,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: !answered
                      ? null
                      : () {
                          setState(() {
                            question = widget.questionProvider.getNewQuestion(
                                category: widget.category.id,
                                difficulty: widget.difficulty.id);
                            answered = false;
                            questionNumber++;
                            countdown();
                          });
                        },
                  child: const Text('Next question'),
                ),
              ];
            } else if (snapshot.hasError) {
              // TODO: Check why this doesn't work properly anymore
              children = <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        question = widget.questionProvider.getNewQuestion(
                            category: widget.category.id,
                            difficulty: widget.difficulty.id);
                        countdown();
                      });
                    },
                    child: const Text("Try again"))
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                ),
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          },
        ));
  }
}
