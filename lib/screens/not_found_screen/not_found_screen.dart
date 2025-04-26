import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  static String routeName = "/not-found";

  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('Page not found'));
  }
}
