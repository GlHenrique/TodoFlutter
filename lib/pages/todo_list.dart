import 'package:flutter/material.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final addTaskController = TextEditingController();
  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoIndex;

  void handleAdd() {
    if (addTaskController.text == '') return;
    setState(() {
      Todo newTodo = Todo(title: addTaskController.text, date: DateTime.now());
      todos.add(newTodo);
    });
    addTaskController.clear();
  }

  void undo() {
    setState(() {
      todos.insert(deletedTodoIndex!, deletedTodo!);
    });
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoIndex = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });

    // Dismiss current snackbar if exists
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com suceso!',
        ),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            undo();
          },
          textColor: Colors.white,
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void clearAll() {
    if (todos.isEmpty) return;
    setState(() {
      todos.clear();
      Navigator.of(context).pop();
    });
  }

  void showDeleteConfirmAll() {
    if (todos.isEmpty) return;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Limpar tudo?'),
              content: const Text('Esta ação removerá todas as tarefas'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Não')),
                TextButton(
                    onPressed: () {
                      clearAll();
                    },
                    child: const Text('Sim')),
              ],
            ));
    // setState(() {
    //   todos.clear();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
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
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          item: todo,
                          onDelete: onDelete,
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text('Você possui ${todos.length} tarefas pendentes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDeleteConfirmAll();
                      },
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
      ),
    );
  }
}
