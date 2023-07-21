import 'package:flutter/material.dart';

import '../../features/auth/presentation/view/login_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
      case RouteNames.initial:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );

      case RouteNames.employees:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Employees')),
          settings: settings,
        );

      case RouteNames.employeeDetails:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Employees Details')),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
