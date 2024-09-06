import 'dart:async';
import 'package:assignment_todo/component/todo_detail.dart';
import 'package:assignment_todo/db/db_helper.dart';
import 'package:assignment_todo/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoScreenState();
  }
}

class TodoScreenState extends State<TodoScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList = List<Todo>.empty(growable: true); // Null safety
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todoList.isEmpty) {
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Todo('', '', ''), 'Add Todo');
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(todoList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(todoList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(todoList[position].description),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.red),
              onTap: () {
                _delete(context, todoList[position]);
              },
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(todoList[position], 'Edit Todo');
            },
          ),
        );
      },
    );
  }

  String getFirstLetter(String title) {
    return title.isNotEmpty ? title.substring(0, 1) : '?';
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id!);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar); // Use ScaffoldMessenger
  }

  void navigateToDetail(Todo todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}
