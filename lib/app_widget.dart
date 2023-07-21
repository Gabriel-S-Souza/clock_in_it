import 'package:flutter/material.dart';

import 'features/auth/presentation/view/login_screen.dart';
import 'setup/routes/app_routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Clock In It',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
        home: LoginScreen(),
      );
}
