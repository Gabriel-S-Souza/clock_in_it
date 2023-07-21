import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app_widget.dart';
import 'setup/http/dio_app.dart';
import 'setup/service_locator/service_locator_imp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocatorImp(GetIt.instance).setup();
  runApp(const AppWidget());
  final responseTest = await dioApp.post(
    'refresh-token',
    data: {
      'username': 'admin',
      'password': 'admin',
    },
  );

  print(responseTest.data);
}
