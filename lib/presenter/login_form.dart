import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_puzzler/infra/services/auth_provider.dart';

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
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, child) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Center(
            child: Text(
              auth.user != null
                  ? 'Logged in as ${auth.user!.name}'
                  : 'Not logged in',
            ),
          ),
          const SizedBox(height: 16.0),
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
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              auth.emailLogin(emailController.text, passwordController.text);
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              auth.register(emailController.text, passwordController.text,
                  nameController.text);
            },
            child: const Text('Register'),
          ),
          ElevatedButton(
            onPressed: () {
              auth.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      );
    });
  }
}
