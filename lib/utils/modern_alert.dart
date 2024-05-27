import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void ModernAlert(BuildContext context, String title, String message, String buttonText, Future? Function() param4) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      content: Text(message, style: const TextStyle(fontSize: 16.0)),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          isDestructiveAction: false,
          child: Text(buttonText),
        ),
      ],
    ),
  );
}