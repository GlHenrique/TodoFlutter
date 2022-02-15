import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/models/todo.dart';

class TodoRepository {
  late SharedPreferences sharedPreferences;
  String todoListKey = 'TODO_LIST_KEY';

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List todoList = json.decode(jsonString) as List;
    return todoList.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> list) {
    final jsonString = json.encode(list);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
