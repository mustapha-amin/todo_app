import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  String todo;
  @HiveField(1)
  DateTime time;
  @HiveField(2)
  bool completed;
  @HiveField(3)
  int? categoryIndex;
  TodoModel(
      {required this.todo,
      required this.time,
      required this.completed,
      required this.categoryIndex});

  @override
  bool operator ==(covariant Object other) {
    return identical(this, other) ||
        other is TodoModel &&
            time == other.time &&
            todo == other.todo &&
            completed == other.completed &&
            categoryIndex == other.categoryIndex;
  }

  @override
  int get hashCode => todo.hashCode ^ time.hashCode ^ completed.hashCode;
}

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  String todoCategory;
  @HiveField(1)
  List<TodoModel>? taskList;
  Todo({required this.todoCategory, required this.taskList});

  addTask(TodoModel todo) {
    taskList!.add(todo);
  }
}