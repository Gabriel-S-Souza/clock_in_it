
import 'package:flutter/material.dart';

import 'route_names.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => Container(child: const Text('Home')),
          settings: settings,
        );
      
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => Container(child: const Text('Login')),
          settings: settings,
        );
      
      case RouteNames.employees:
        return MaterialPageRoute(
          builder: (_) => Container(child: const Text('Employees')),
          settings: settings,
        );
      
      case RouteNames.employeeDetails:
        return MaterialPageRoute(
          builder: (_) => Container(child: const Text('Employees Details')),
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