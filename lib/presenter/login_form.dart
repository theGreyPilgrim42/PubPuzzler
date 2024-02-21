import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_puzzler/infra/services/auth_provider.dart';
import 'package:pub_puzzler/infra/services/game_provider.dart';
import 'package:pub_puzzler/main.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, child) {
      return Card(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await auth.emailLogin(
                      emailController.text, passwordController.text);
                  if (!context.mounted) return;

                  if (auth.hasError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(auth.errorSnackBar);
                    return;
                  }

                  if (auth.user != null) {
                    Provider.of<GameProvider>(context, listen: false)
                        .getGames(auth.userId!);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PubPuzzlerApp()),
                        (route) => false);
                  }
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await auth.register(
                      emailController.text, passwordController.text);
                  if (!context.mounted) return;

                  if (auth.hasError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(auth.errorSnackBar);
                    return;
                  }

                  if (auth.user != null) {
                    Provider.of<GameProvider>(context, listen: false)
                        .getGames(auth.userId!);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PubPuzzlerApp()),
                        (route) => false);
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ]),
      );
    });
  }
}
