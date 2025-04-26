import 'package:flutter/material.dart';

import '../../screens/not_found_screen/not_found_screen.dart';

class DynamicRouterConfig {
  static final routes = {};

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeBuilder = routes[settings.name];
    final nextScreen = routeBuilder == null
        ? const NotFoundScreen()
        : routeBuilder(settings.arguments);

    return MaterialPageRoute(builder: (context) => nextScreen);
  }
}
