import 'package:flutter/material.dart';

import 'setup/routes/app_routes.dart';
import 'setup/routes/route_names.dart';
import 'shared/presentation/toast/view/toast_zone.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => const Stack(
        textDirection: TextDirection.ltr,
        children: [
          MaterialApp(
            title: 'Clock In It',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: RouteNames.login,
          ),
          ToastZone(),
        ],
      );
}
