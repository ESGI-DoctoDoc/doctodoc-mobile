import 'package:doctodoc_mobile/screens/introcution_screen.dart';
import 'package:doctodoc_mobile/shared/config/dynamic_router_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doctodoc_mobile/shared/config/theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String titleApp = 'DoctoDoc';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: titleApp,
        onGenerateRoute: DynamicRouterConfig.generateRoute,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: IntroductionScreen()
      ),
    );
  }
}
