import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/db_helper.dart';
import '../model/todo_model.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todoList = [];
  DatabaseHelper _dbHelper = DatabaseHelper();

  List<Todo> get todoList => _todoList;

  Future<void> loadTodos() async {
    _todoList = await _dbHelper.getTodoList();
    notifyListeners();
  }

  Future<void> addTodo(String title, String description) async {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Todo newTodo = Todo(title, currentDate, description);
    await _dbHelper.insertTodo(newTodo);
    loadTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    todo.date = currentDate;
    await _dbHelper.updateTodo(todo);
    loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await _dbHelper.deleteTodo(id);
    loadTodos();
  }
}
