import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_puzzler/infra/services/game_provider.dart';
import 'package:pub_puzzler/presenter/add_question_widget.dart';
import 'package:pub_puzzler/presenter/choose_type_widget.dart';
import 'presenter/color_schemes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => GameProvider(),
      child: MaterialApp(
        title: 'Pub Puzzler',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: const PubPuzzlerApp(),
      ),
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
