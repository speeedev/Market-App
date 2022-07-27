import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void ModernAlertTwoButton(BuildContext context, String title, String message, String buttonText1, String buttonText2, Function function1, Function function2) {
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
            function1();
          },
          child: Text(buttonText1),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
            function2();
          },
          child: Text(buttonText2),
        ),
      ],
    ),
  );
}