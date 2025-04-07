class Todo {
  final String id;
  final String description;
  final bool completed;

  Todo({required this.id, required this.description, this.completed = false});

  // Convert a Todo into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'completed': completed ? 1 : 0,
    };
  }

  // Convert a Map into a Todo
  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      description: map['description'],
      completed: map['completed'] == 1,
    );
  }
}
