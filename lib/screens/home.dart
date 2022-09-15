import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/screens/todoview.dart';
import 'package:todo_app/shared/spacing.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../shared/drawer.dart';
import 'categories.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box<Todo> todoBox = Hive.box<Todo>('todoBox');
  List<TodoModel> tasksForToday = [];
  bool switchSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.purple[50],
        elevation: 0,
      ),
      body: Container(
          height: double.infinity,
          child: ValueListenableBuilder<Box<Todo>>(
            valueListenable: todoBox.listenable(),
            builder: (context, box, _) {
              return Container(
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addVerticalSpace(24),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "To-doo",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: categoriesWidget()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: tasksForToday.isNotEmpty
                            ? const Text(
                                "Tasks for today",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: dailyTasks(),
                    ),
                  ],
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.purple[600],
        onPressed: () {
          Navigator.pushNamed(context, '/addtask');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Container categoriesWidget() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 150,
      ),
      child: ListView.builder(
        itemCount: todoBox.values.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var category = todoBox.values.elementAt(index);
          int length = todoBox.getAt(index)!.taskList!.length;
          return Container(
            constraints: const BoxConstraints(maxHeight: 300),
            padding: const EdgeInsets.all(8),
            height: 100,
            width: 250,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TodoViewer(
                        index: index,
                      );
                    },
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 5,
                shadowColor: Colors.grey[400],
                child: Column(
                  children: [
                    addVerticalSpace(40),
                    Text(
                      category.todoCategory,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    addVerticalSpace(5),
                    Text(length == 1 ? "$length task" : "$length tasks")
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container dailyTasks() {
    var padding = EdgeInsets.only(left: 10, right: 10);
    return Container(
      height: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, box, _) {
          todoBox.values.forEach((category) {
            category.taskList!.forEach((todo) {
              if (todo.time.day == DateTime.now().day &&
                  !tasksForToday.contains(todo)) {
                tasksForToday.add(todo);
                tasksForToday.sort(((a, b) => a.time.compareTo(b.time)));
              }
            });
          });
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: tasksForToday.length,
            itemBuilder: (context, index) {
              var item = tasksForToday[index];
              var time =
                  TimeOfDay(hour: item.time.hour, minute: item.time.minute);
              return Padding(
                padding: padding,
                child: Container(
                  height: 80,
                  color: Colors.purple[50],
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        shape: const CircleBorder(),
                        activeColor: Colors.purple[900],
                        value: item.completed,
                        onChanged: (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Task completed"),
                              duration: Duration(milliseconds: 200),
                            ),
                          );
                          setState(() {
                            item.completed = true;
                          });
                          Timer.periodic(const Duration(milliseconds: 500),
                              (_) {
                            todoBox.values.forEach((category) {
                              category.taskList!.forEach((todo) {
                                if (todo == item) {
                                  category.taskList!.remove(todo);
                                  category.save();
                                }
                              });
                            });
                            setState(() {
                              tasksForToday.remove(item);
                            });
                          });
                        },
                      ),
                      title: Text(
                        item.todo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: item.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(todoBox.values
                          .elementAt(item.categoryIndex!)
                          .todoCategory),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat().add_jm().format(item.time),
                            style: const TextStyle(color: Colors.green),
                          ),
                          const Icon(Icons.alarm)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
