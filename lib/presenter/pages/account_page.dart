import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_puzzler/infra/services/auth_provider.dart';
import 'package:pub_puzzler/infra/services/game_provider.dart';
import 'package:pub_puzzler/presenter/pages/login_form.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, GameProvider>(
        builder: (context, auth, game, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Provider.of<AuthProvider>(context, listen: false)
                        .user!
                        .email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  "E-Mail",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${Provider.of<GameProvider>(context, listen: false).totalScore}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    "Score",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
              const VerticalDivider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${Provider.of<GameProvider>(context, listen: false).accuracy.toStringAsFixed(1)} %",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    "Degree of correctness",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginForm()),
                  (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      );
    });
  }
}
