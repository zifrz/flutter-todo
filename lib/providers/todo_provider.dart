import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/todo.dart';
import 'database_helper.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  final DatabaseHelper _dbHelper;

  TodoNotifier(this._dbHelper) : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final todos = await _dbHelper.getTodos();
    state = todos;
  }

  // Add a new todo
  Future<void> addTodo(Todo todo) async {
    await _dbHelper.insertTodo(todo);
    state = [...state, todo];
  }

  // Toggle completion status
  Future<void> toggleTodo(String id) async {
    final newState =
        state.map((todo) {
          if (todo.id == id) {
            final updatedTodo = Todo(
              id: todo.id,
              description: todo.description,
              completed: !todo.completed,
            );
            _dbHelper.updateTodo(updatedTodo);
            return updatedTodo;
          }
          return todo;
        }).toList();

    state = newState;
  }

  // Update todo description
  Future<void> updateTodo(String id, String newDescription) async {
    final newState =
        state.map((todo) {
          if (todo.id == id) {
            final updatedTodo = Todo(
              id: todo.id,
              description: newDescription,
              completed: todo.completed,
            );
            _dbHelper.updateTodo(updatedTodo);
            return updatedTodo;
          }
          return todo;
        }).toList();

    state = newState;
  }

  // Remove a todo
  Future<void> removeTodo(String id) async {
    await _dbHelper.deleteTodo(id);
    state = state.where((todo) => todo.id != id).toList();
  }
}

// Riverpod provider
final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier(DatabaseHelper.instance);
});
