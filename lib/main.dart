import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:pub_puzzler/infra/services/auth_provider.dart';
import 'package:pub_puzzler/infra/services/game_provider.dart';
import 'package:pub_puzzler/infra/services/logger_util.dart';
import 'package:pub_puzzler/infra/services/question_provider.dart';
import 'package:pub_puzzler/presenter/pages/account_page.dart';
import 'package:pub_puzzler/presenter/pages/choose_type_form.dart';
import 'package:pub_puzzler/presenter/pages/login_form.dart';
import 'package:pub_puzzler/presenter/widgets/custom_error_widget.dart';
import 'presenter/color_schemes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogger();
  final logger = getLogger();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    logger.e(details.exception);
    if (kDebugMode) {
      return CustomErrorWidget(errorMessage: details.exception.toString());
    }
    return const CustomErrorWidget(
        errorMessage: 'We are sorry for any inconvenience');
  };
  await dotenv.load();
  await GlobalConfiguration().loadFromAsset("app_settings");

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider()),
        ChangeNotifierProvider<GameProvider>(
            create: (context) => GameProvider()),
        ChangeNotifierProvider<QuestionProvider>(
            create: (context) => QuestionProvider()),
      ],
      child: MaterialApp(
        title: GlobalConfiguration().getValue('appName'),
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: const Scaffold(body: LoginForm()),
      ),
    );
  }
}

class PubPuzzlerApp extends StatefulWidget {
  const PubPuzzlerApp({super.key});

  @override
  State<PubPuzzlerApp> createState() => _PubPuzzlerAppState();
}

class _PubPuzzlerAppState extends State<PubPuzzlerApp> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // Header container
        appBar: AppBar(
          title: Text(GlobalConfiguration().getValue('appName')),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.quiz)),
            Tab(icon: Icon(Icons.account_circle_outlined)),
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
            AccountPage()
          ],
        ),
      ),
    );
  }
}
