import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/todo_model.dart';

class OverduePage extends StatefulWidget {
  const OverduePage({Key? key}) : super(key: key);
  @override
  State<OverduePage> createState() => _OverduePageState();
}

class _OverduePageState extends State<OverduePage> {
  List<TodoModel> overdue = [];
  final Box<Todo> todoBox = Hive.box<Todo>('todoBox');

  @override
  void initState() {
    todoBox.values.forEach((category) {
      category.taskList!.forEach((todo) {
        if (todo.time.day < DateTime.now().day) {
          overdue.add(todo);
        }
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text("Overdue tasks"),
        backgroundColor: Colors.purple[50],
        foregroundColor: Colors.purple[500],
        elevation: 0,
      ),
      body: overdue.isEmpty
          ? const Center(
              child: Text(
                "Empty",
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              itemCount: overdue.length,
              itemBuilder: (context, index) {
                var item = overdue[index];
                return Container(
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
                            if(this.mounted) {
                              setState(() {
                                overdue.remove(item);
                              });
                            }
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
                );
              },
            ),
    );
  }
}
