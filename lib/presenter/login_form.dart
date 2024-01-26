import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Account account;

  const LoginForm({
    super.key,
    required this.account
  });

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  User? loggedInUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> login(String email, String password) async {
    await widget.account.createEmailSession(email: email, password: password);
    final user = await widget.account.get();
    setState(() {
      loggedInUser = user;
    });
  }

  Future<void> register(String email, String password, String name) async {
    await widget.account.create(
        userId: ID.unique(), email: email, password: password, name: name);
    await login(email, password);
  }

  Future<void> logout() async {
    await widget.account.deleteSession(sessionId: 'current');
    setState(() {
      loggedInUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      children: <Widget>[
        Center(
          child: Text(
            loggedInUser != null ? 'Logged in as ${loggedInUser!.name}' : 'Not logged in',
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
            login(emailController.text, passwordController.text);
          },
          child: const Text('Login'),
        ),
        ElevatedButton(
          onPressed: () {
            register(emailController.text, passwordController.text,
                nameController.text);
          },
          child: const Text('Register'),
        ),
        ElevatedButton(
          onPressed: () {
            logout();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
