import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void ModernAlert(BuildContext context, String title, String message, String buttonText, Function function) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      content: Text(message, style: TextStyle(fontSize: 16.0)),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(buttonText),
          isDestructiveAction: false,
        ),
      ],
    ),
  );
}