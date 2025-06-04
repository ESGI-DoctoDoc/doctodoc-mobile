import 'package:flutter/material.dart';

import '../../exceptions/app_exception.dart';

void showErrorSnackbar(BuildContext context, dynamic error) {
  String message = switch (error) {
    AppException e => e.code,
    Exception e => "Une erreur est survenue : ${e.toString()}",
    _ => "Une erreur inattendue est survenue.",
  };
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}