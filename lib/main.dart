import 'package:flutter/material.dart';
import 'package:pub_puzzler/domain/question.dart';
import 'package:pub_puzzler/infra/datasources/question.dart';
import 'package:pub_puzzler/presenter/add_question_widget.dart';
import 'package:pub_puzzler/presenter/choose_type_widget.dart';
import 'presenter/answer_tile.dart';
import 'presenter/color_schemes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pub Puzzler',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const PubPuzzlerApp(),
    );
  }
}

// TODO: Refactor to manage state in PubPuzzlerApp Widget
class PubPuzzlerApp extends StatefulWidget {
  const PubPuzzlerApp({
    super.key,
  });

  @override
  State<PubPuzzlerApp> createState() => _PubPuzzlerAppState();
}

class _PubPuzzlerAppState extends State<PubPuzzlerApp> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          // Header container
          appBar: AppBar(
            title: const Text('Pub Puzzler'),
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.quiz)),
              Tab(icon: Icon(Icons.add_circle_outline)),
              Tab(icon: Icon(Icons.insert_chart_outlined_rounded)),
            ]),
          ),
          body: const TabBarView(
            children: [
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChooseQuestionTypeForm(),
                  ],
                ),
              ),
              AddQuestionForm(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insert_chart_outlined_rounded),
                  Text('Statistics'),
                ]
              ),
            ],
          ),
        ),
      );
  }
}

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
  int score = 0;

  void updateScore() {
    setState(() {
      score += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Score: $score',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          QuestionCard(updateScore: updateScore, category: widget.category, difficulty: widget.difficulty),
        ],
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.updateScore,
    required this.category,
    required this.difficulty,
  });

  final Function updateScore;
  final Category category;
  final Difficulty difficulty;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> with TickerProviderStateMixin {
  late Future<Question> question = fetchQuestion(category: widget.category.id, difficulty: widget.difficulty.id);
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
      question.then((q) => answer == q.correctAnswer ? (q.answerState = AnswerState.correct, widget.updateScore()) : q.answerState = AnswerState.incorrect);
      answered = true;
    });
  }

  Future<void> countdown() async {
    animationController.reset();
    await animationController.forward();
    if (animationController.status == AnimationStatus.completed && !answered) {
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
          if (snapshot.hasData) {
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
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                            snapshot.data!.answerState == AnswerState.correct ? 'Correct!' : 'Incorrect!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: snapshot.data!.answerState == AnswerState.correct ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: !answered ? null : () {
                  setState(() {
                    question = fetchQuestion(category: widget.category.id, difficulty: widget.difficulty.id);
                    answered = false;
                    questionNumber++;
                    countdown();
                  });
                }, 
                child: const Text('Next question'),
              ),
            ];
          } else if (snapshot.hasError) {
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
      )
    );
  }
}
