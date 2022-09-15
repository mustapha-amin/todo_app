import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:todo_app/screens/categories.dart';
import 'models/todo_model.dart';
import 'screens/home.dart';
import 'screens/add_task.dart';

final Box<Todo> todoBox = Hive.box<Todo>('todoBox');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todoBox');
  // default categories
  Iterable<Todo> todoCategories = [
    Todo(todoCategory: "Personal", taskList: []),
    Todo(todoCategory: "Work", taskList: []),
    Todo(todoCategory: "Business", taskList: []),
    Todo(todoCategory: "School", taskList: []),
    Todo(todoCategory: "Fitness", taskList: []),
  ];
  todoBox.isEmpty ? todoBox.addAll(todoCategories) : null;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: HomeScreen(),
      routes: {
        '/categories': (context) => CategoriesPage(),
        '/addtask': (context) => AddTask(),
      },
    ),
  );
}
