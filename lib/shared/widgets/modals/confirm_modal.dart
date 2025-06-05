import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfirmModal(BuildContext context, String title) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('Confirmation'),
        content: Text(title),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Non'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Oui'),
          ),
        ],
      );
    },
  );
}
