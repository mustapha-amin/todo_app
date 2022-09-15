import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  String? message;
  ErrorDialog({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message!),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        )
      ],
    );
  }
}
