import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<String> todos = [];
  final addTaskController = TextEditingController();

  void handleAdd() {
    if (addTaskController.text == '') return;
    setState(() {
      todos.add(addTaskController.text);
    });
    print(todos);
    addTaskController.clear();
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                      ),
                      controller: addTaskController,
                      onSubmitted: (_) {
                        handleAdd();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      handleAdd();
                    },
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff00d7f3),
                      padding: const EdgeInsets.all(15),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (String todo in todos)
                      ListTile(
                        title: Text(todo),
                        subtitle: const Text('09/02/2022'),
                        leading: const Icon(
                          Icons.save,
                          size: 16,
                        ),
                        onTap: () {
                          print(todo);
                        },
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text('Você possui 0 tarefas pendentes'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Limpar tudo'),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff00d7f3),
                      padding: const EdgeInsets.all(15),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
