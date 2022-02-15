import 'package:flutter/material.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/repositories/todo_repository.dart';
import 'package:todo_flutter/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final addTaskController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoIndex;
  String? errorText;

  void handleAdd() {
    if (addTaskController.text == '') {
      setState(() {
        errorText = 'Tarefa inválida';
      });
      return;
    }

    setState(() {
      Todo newTodo = Todo(title: addTaskController.text, date: DateTime.now());
      todos.add(newTodo);
      todoRepository.saveTodoList(todos);
      errorText = null;
    });
    addTaskController.clear();
  }

  void undo() {
    setState(() {
      todos.insert(deletedTodoIndex!, deletedTodo!);
      todoRepository.saveTodoList(todos);
    });
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoIndex = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
      todoRepository.saveTodoList(todos);
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
      todoRepository.saveTodoList(todos);
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
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              clearAll();
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
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
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            errorText: errorText,
                            labelStyle: const TextStyle(
                              color: Color(0xff00d7f3),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff00d7f3),
                                width: 2,
                              ),
                            ),
                          ),
                          controller: addTaskController,
                          onSubmitted: (_) {
                            handleAdd();
                          },
                          onChanged: (_) {
                            setState(() {
                              errorText = null;
                            });
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
