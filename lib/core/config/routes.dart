import 'package:flutter/material.dart';
import '../utils/logger.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    AppLogger.info('Navigating to route: ${settings.name}');
    switch (settings.name) {
      // case SplashScreen.routeName:
      //   return SplashScreen.route();
      // case HomeScreen.routeName:
      //   return HomeScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: '/error'),
        builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Center(child: Text('Error Page')),
              ),
            ));
  }
}
