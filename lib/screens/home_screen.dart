import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/todo.dart';
import 'package:myapp/providers/todo_provider.dart';
import 'package:myapp/widgets/todo_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo App')),
      body:
          todos.isEmpty
              ? const Center(child: Text("No todos available"))
              : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) => TodoTile(todo: todos[index]),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTodoDialog(context, ref);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text("Add Todo"),
      ),
    );
  }

  // Show a dialog to add a todo
  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController todoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Todo"),
          content: TextField(
            controller: todoController,
            decoration: const InputDecoration(
              hintText: "Enter todo description",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                if (todoController.text.trim().isNotEmpty) {
                  final newTodo = Todo(
                    id: DateTime.now().toString(),
                    description: todoController.text.trim(),
                  );
                  ref.read(todoProvider.notifier).addTodo(newTodo);
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
