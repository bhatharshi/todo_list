import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider.dart';
import '../model/todo_model.dart';
import '../component/todo_detail.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    // Load todos when the screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: todoProvider.todoList.isEmpty
          ? const Center(
              child: Text('No Data Found'),
            )
          : ListView.builder(
              itemCount: todoProvider.todoList.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todoList[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(
                        getFirstLetter(todo.title),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      todo.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(todo.description),
                    trailing: GestureDetector(
                      child: const Icon(Icons.delete, color: Colors.red),
                      onTap: () {
                        todoProvider.deleteTodo(todo.id!);
                        _showSnackBar(context, 'Todo Deleted Successfully');
                      },
                    ),
                    onTap: () {
                      navigateToDetail(context, todo, 'Edit Todo');
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(context, Todo('', ''), 'Add Todo');
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  void navigateToDetail(BuildContext context, Todo todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title);
    }));

    if (result == true) {
      Provider.of<TodoProvider>(context, listen: false).loadTodos();
    }
  }

  String getFirstLetter(String title) {
    return title.isNotEmpty ? title.substring(0, 1) : '?';
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
