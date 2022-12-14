import 'package:flutter/material.dart';
import 'package:todo_app/screens/overdue.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool switchSelected = false;
  String aboutText = """A simple todo app developed by mustapha
""";
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenwidth - 50,
      backgroundColor: Colors.purple[900],
      child: ListView(
        children: [
          const DrawerHeader(child: FlutterLogo()),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
            title: const Text(
              "Dark mode(coming soon..)",
              style: TextStyle(
                color: Color.fromARGB(255, 147, 161, 243),
              ),
            ),
            trailing: Switch(
                value: switchSelected,
                activeColor: Colors.green,
                onChanged: (_) {
                  setState(() {
                    switchSelected = !switchSelected;
                  });
                }),
          ),
          ListTile(
            leading: const Icon(
              Icons.category_outlined,
              color: Colors.white,
              size: 20,
            ),
            title: const Text(
              "categories",
              style: TextStyle(color: Color.fromARGB(255, 147, 161, 243)),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/categories');
            },
          ),
          ListTile(
            title: const Text("Overdue",
                style: TextStyle(color: Color.fromARGB(255, 147, 161, 243))),
            leading: const Icon(
              Icons.timer_off_rounded,
              color: Colors.white,
              size: 20,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const OverduePage();
              }));
            },
          ),
          const ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
            title: Text(
              "Settings",
              style: TextStyle(color: Color.fromARGB(255, 147, 161, 243)),
            ),
          ),
          AboutListTile(
            icon: const Icon(Icons.info, color: Colors.white),
            applicationName: "To-doo",
            applicationVersion: "V-1.0",
            applicationIcon: const FlutterLogo(),
            aboutBoxChildren: [
              Text(aboutText),
            ],
            child: const Text(
              "About",
              style: TextStyle(
                color: Color.fromARGB(255, 147, 161, 243),
              ),
            ),
          )
        ],
      ),
    );
  }
}
