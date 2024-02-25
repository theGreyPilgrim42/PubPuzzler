import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_puzzler/domain/entities/question_entity.dart';
import 'package:pub_puzzler/infra/services/auth_provider.dart';
import 'package:pub_puzzler/infra/services/game_provider.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';
import 'package:pub_puzzler/presenter/pages/question_screen.dart';
import 'package:pub_puzzler/presenter/widgets/custom_dropdown_button.dart';

class ChooseQuestionTypeForm extends StatefulWidget {
  const ChooseQuestionTypeForm({super.key});

  @override
  ChooseQuestionTypeState createState() {
    return ChooseQuestionTypeState();
  }
}

class ChooseQuestionTypeState extends State<ChooseQuestionTypeForm> {
  final _formKey = GlobalKey<FormState>();
  final logger = getLogger();
  final List<String> categoryList = [
    'Random',
    ...Category.values.map((e) => e.name.toString())
  ];
  final List<String> difficultyList = [
    'Random',
    ...Difficulty.values.map((e) => e.name.toString())
  ];
  late Category chosenCategory;
  late Difficulty chosenDifficulty;

  void setCategory(String category) {
    setState(() {
      chosenCategory = Category.fromString(category);
    });
  }

  void setDifficulty(String difficulty) {
    setState(() {
      chosenDifficulty = Difficulty.fromString(difficulty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        children: [
          CustomDropdownButton(
              list: categoryList, hint: 'Category', callback: setCategory),
          CustomDropdownButton(
              list: difficultyList,
              hint: 'Difficulty',
              callback: setDifficulty),
          ElevatedButton(
            onPressed: () async {
              if (!context.mounted) return;
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                logger.i('Chosen category: $chosenCategory');
                logger.i('Chosen difficulty: $chosenDifficulty');
                logger.d('Starting quiz...');
                if (!context.mounted) return;

                String userId =
                    Provider.of<AuthProvider>(context, listen: false).userId!;
                Provider.of<GameProvider>(context, listen: false)
                    .addNewGame(userId);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(
                      category: chosenCategory,
                      difficulty: chosenDifficulty,
                    ),
                  ),
                );
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.start),
                Text('Start Quiz'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
