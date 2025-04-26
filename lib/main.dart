import 'package:doctodoc_mobile/shared/config/dynamic_router_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String titleApp = 'DoctoDoc';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: titleApp,
      onGenerateRoute: DynamicRouterConfig.generateRoute,
      home: Placeholder(
        child: Center(child: Text('hello world')),
      ),
    );
  }
}
