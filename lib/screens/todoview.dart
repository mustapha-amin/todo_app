import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/todo_model.dart';

class TodoViewer extends StatefulWidget {
  int index;
  TodoViewer({Key? key, required this.index}) : super(key: key);

  @override
  State<TodoViewer> createState() => _TodoViewerState();
}

class _TodoViewerState extends State<TodoViewer> {
  final Box<Todo> todoBox = Hive.box<Todo>('todoBox');
  final List<TodoModel> taskList = [];
  Todo? todos;
  String taskCopy = '';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (todoBox.containsKey(widget.index)) {
      todos = todoBox.get(widget.index);
      taskList.addAll(todos!.taskList as Iterable<TodoModel>);
      taskList.sort(((a, b) => a.time.compareTo(b.time)));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(todos!.todoCategory,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true),
      body: taskList.isEmpty
          ? const Center(
              child: Text("No task yet",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            )
          : ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                TodoModel task = taskList[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                              const Text("Do you want to delete ths task?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                todos!.taskList!.removeAt(index);
                                Navigator.pop(context);
                                todos!.save();
                              },
                              child: const Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(task.todo),
                      subtitle: Text(
                        taskList[index].time.hour < 12
                            ? "${task.time.toString().substring(11, 16)}am"
                            : "${task.time.toString().substring(11, 16)}pm",
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            _controller.text = task.todo;
                            taskCopy = task.todo;
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Edit task"),
                                    content: TextField(
                                      controller: _controller,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (taskCopy == _controller.text) {
                                            null;
                                          } else {
                                            var edittask = todos!.taskList!
                                                .elementAt(index);
                                            edittask.todo = _controller.text;
                                            todos!.save();
                                            setState(() {});
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text("Save"),
                                      )
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.edit)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
