import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/models/todo_model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Box<Todo> todoBox = Hive.box<Todo>('todoBox');
  TextEditingController _controller = TextEditingController();

  // Can't be deleted
  var defaultCategory = ["Personal", "Work", "Business", "School", "Fitness"];
  var categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoBox.values.forEach((category) {
      categories.add(category.todoCategory);
    });
  }

  _refresh() {
    setState(() {
      categories.clear();
      todoBox.values.forEach((category) {
        categories.add(category.todoCategory);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text("Categories"),
        centerTitle: true,
        backgroundColor: Colors.purple[50],
        foregroundColor: Colors.purple[500],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.list),
            title: Text(categories[index]),
            trailing: defaultCategory.contains(categories[index])
                ? null
                : IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text("Delete category?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      todoBox.deleteAt(index);
                                      categories.removeAt(index);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("No")),
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.delete),
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add categpory"),
                content: TextField(
                  maxLength: 12,
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
                      if (_controller.text != null) {
                        setState(() {
                          todoBox.add(Todo(
                              todoCategory: _controller.text, taskList: []));
                          _refresh();
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  )
                ],
              );
            },
          );
        },
        backgroundColor: Colors.purple,
        tooltip: "Add category",
        child: const Icon(Icons.add),
      ),
    );
  }
}
