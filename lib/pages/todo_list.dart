import 'package:flutter/material.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Expanded(
                  child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Adicione uma tarefa',
                ),
              )),
              const SizedBox(width: 8),
              ElevatedButton(
                  onPressed: () {},
                  child: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff00d7f3),
                    padding: const EdgeInsets.all(15),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
