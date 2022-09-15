import 'package:date_time_picker/date_time_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:todo_app/api/notification.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/shared/error_widget.dart';
import 'package:todo_app/shared/spacing.dart';

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  static const todoBox = 'todoBox';
  final Box<Todo> box = Hive.box<Todo>(todoBox);
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  int? index = 0;
  String? errorMessage;
  List<String>? categories;

  @override
  void initState() {
    categories = box.values.map((e) => e.todoCategory).toList();
    super.initState();
  }

  void save() {
    if (_controller1.text.isEmpty) {
      errorMessage = "Add a task";
    } else if (_controller2.text.isEmpty) {
      errorMessage = "Add date and time";
    }
    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty) {
      Todo todo = box.get(index)!;
      todo.taskList!.add(
        TodoModel(
            todo: _controller1.text,
            time: DateTime.parse(_controller2.text),
            completed: false,
            categoryIndex: index!),
      );
      todo.save();
      Navigator.pop(context);
      NotificationApi.shownotification(
          title: "New task added",
          body: _controller1.text,
          payload: 'task.abs');
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            message: errorMessage,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[600],
        title: const Text("Add a task"),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  cursorColor: Colors.purple,
                  controller: _controller1,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      hintText: "Add task", icon: Icon(Icons.add_task)),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: DateTimePicker(
                    dateHintText: "Select date and time",
                    icon: const Icon(Icons.date_range),
                    type: DateTimePickerType.dateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                    initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                    controller: _controller2,
                  )),
              addVerticalSpace(20),
              const Text(
                "Select Category",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 15.0,
                alignment: WrapAlignment.start,
                children: [
                  ...categories!.map((category) {
                    return ChoiceChip(
                        labelPadding: const EdgeInsets.only(left: 7, right: 7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        selectedColor: Colors.purple[600],
                        label: Text(
                          category,
                          style: const TextStyle(color: Colors.black),
                        ),
                        selected: index == categories!.indexOf(category),
                        onSelected: (selected) {
                          setState(() {
                            index = selected
                                ? categories!.indexOf(category)
                                : index;
                          });
                        });
                  }).toList(),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height / 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                save();
              },
              color: Colors.purple[600],
              child: const Text(
                "Add task",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
