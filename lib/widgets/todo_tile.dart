import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/todo.dart';
import 'package:myapp/providers/todo_provider.dart';

class TodoTile extends ConsumerWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (value) {
            ref.read(todoProvider.notifier).toggleTodo(todo.id);
          },
        ),
        title: Text(
          todo.description,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              onPressed: () {
                _showEditTodoDialog(context, ref, todo);
              },
              icon: const Icon(Icons.edit_rounded),
            ),
            IconButton.filledTonal(
              onPressed: () {
                ref.read(todoProvider.notifier).removeTodo(todo.id);
              },
              icon: const Icon(Icons.delete_rounded),
            ),
          ],
        ),
      ),
    );
  }

  // Show a dialog to edit the todo
  void _showEditTodoDialog(BuildContext context, WidgetRef ref, Todo todo) {
    final TextEditingController todoController = TextEditingController(
      text: todo.description,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Todo"),
          content: TextField(
            controller: todoController,
            decoration: const InputDecoration(
              hintText: "Enter new description",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (todoController.text.trim().isNotEmpty) {
                  ref
                      .read(todoProvider.notifier)
                      .updateTodo(todo.id, todoController.text.trim());
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
