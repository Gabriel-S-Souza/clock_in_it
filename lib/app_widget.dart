import 'package:flutter/material.dart';

import 'setup/routes/app_routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Clock In It',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      );
}
