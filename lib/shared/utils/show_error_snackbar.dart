import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../exceptions/app_exception.dart';

class ErrorTranslator {
  static Map<String, String> _translations = {};

  static Future<void> load() async {
    if (_translations.isNotEmpty) return;

    final String data = await rootBundle.loadString('assets/i18n/errors.i18n.json');
    final Map<String, dynamic> jsonMap = json.decode(data);
    _translations = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static String translate(String code) {
    if (_translations.isEmpty) {
      throw Exception("Translations not loaded. Call ErrorTranslator.load() first.");
    }
    return _translations[code] ?? code;
  }
}

void showErrorSnackbar(BuildContext context, dynamic error) {
  String message = switch (error) {
    AppException e => ErrorTranslator.translate(e.code),
    Exception e => "Une erreur est survenue : ${e.toString()}",
    String e => e,
    _ => "Une erreur inattendue est survenue.",
  };
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}