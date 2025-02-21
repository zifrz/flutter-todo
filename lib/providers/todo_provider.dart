import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/todo.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  // Add a new todo
  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  // Toggle completion status
  void toggleTodo(String id) {
    state =
        state.map((todo) {
          if (todo.id == id) {
            return Todo(
              id: todo.id,
              description: todo.description,
              completed: !todo.completed,
            );
          }
          return todo;
        }).toList();
  }

  // Update todo description
  void updateTodo(String id, String newDescription) {
    state =
        state.map((todo) {
          if (todo.id == id) {
            return Todo(
              id: todo.id,
              description: newDescription,
              completed: todo.completed,
            );
          }
          return todo;
        }).toList();
  }

  // Remove a todo
  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

// Riverpod provider
final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
