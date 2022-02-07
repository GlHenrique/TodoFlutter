import 'package:flutter/material.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  String get emailValue => emailController.text;

  void login() {
    print(emailValue);
  }

  void onChangeEmail(String event) {
    print(event);
  }

  void onSubmittedEmail(String event) {
    print(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            onChanged: onChangeEmail,
            onSubmitted: onSubmittedEmail,
          ),
          ElevatedButton(onPressed: login, child: const Text('Entrar'))
        ],
      ),
    )));
  }
}
