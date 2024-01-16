import 'package:flutter/material.dart';
import 'package:pub_puzzler/domain/question.dart';
import 'package:pub_puzzler/presenter/add_question_widget.dart';
import 'package:pub_puzzler/presenter/choose_type_widget.dart';
import 'presenter/color_schemes.dart';
import 'presenter/question_card.dart';

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
