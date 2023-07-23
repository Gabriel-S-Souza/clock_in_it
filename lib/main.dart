import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app_widget.dart';
import 'setup/service_locator/service_locator_imp.dart';
import 'shared/data/services/notifications/notification_imp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocatorImp(GetIt.instance).setup();
  await NotificationServiceImp.I.initialize();
  runApp(const AppWidget());
}
