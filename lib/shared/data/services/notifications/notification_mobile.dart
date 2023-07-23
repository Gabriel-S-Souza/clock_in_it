import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../features/employee/data/models/employee_model.dart';
import '../../../../setup/service_locator/service_locator_imp.dart';
import '../../../domain/repositories/local_storage_repository.dart';
import 'notification_base.dart';

class NotificationService implements NotificationServiceBase {
  late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late final LocalStorageRepository _localStorage;
  late final NotificationDetails _platformChannelSpecifics;
  bool _showPeriodicNotification = false;

  @override
  Future<void> initialize([
    LocalStorageRepository? localStorage,
    FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin,
  ]) async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _localStorage = localStorage ?? ServiceLocatorImp.I.get<LocalStorageRepository>();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );

    const AndroidNotificationDetails androidNotificDetails = AndroidNotificationDetails(
      'clockinit',
      'ClockInIt',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
    );

    _platformChannelSpecifics = const NotificationDetails(
      android: androidNotificDetails,
      iOS: null,
      macOS: null,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        print('onDidReceiveNotificationResponse: $payload');
      },
    );

    show(
      0,
      'Clock In It',
      'Bata o ponto pelo app!',
    );
  }

  @override
  Future<void> show(
    int id,
    String title, [
    String? body,
    String? imagePath,
    bool showButton = false,
  ]) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _platformChannelSpecifics,
    );
  }

  @override
  void activatePeriodicNotification() {
    _showPeriodicNotification = true;
    Timer.periodic(
      const Duration(minutes: 1),
      (timer) async {
        if (!_showPeriodicNotification) {
          timer.cancel();
          return;
        }
        final employees = _getEmployeesFromCache();
        late EmployeeModel randomEmployee;
        final user = _localStorage.getUser();
        final hello = user != null ? 'Oi, ${user.name}' : 'Oi';

        if (employees.isEmpty) {
          return;
        } else {
          randomEmployee = employees[math.Random().nextInt(employees.length)];
        }

        await show(
          0,
          '$hello, veja quem também bateu o ponto no app!',
          '${randomEmployee.name} — id: ${randomEmployee.personalId}',
        );
      },
    );
  }

  @override
  void cancelPeriodicNotification() {
    _showPeriodicNotification = false;
  }

  List<EmployeeModel> _getEmployeesFromCache() {
    final employeesJson = _localStorage.getList('employees');
    if (employeesJson != null) {
      final employees = employeesJson.map((employeeJson) {
        final employeeMap = jsonDecode(employeeJson);

        return EmployeeModel.fromJson(employeeMap);
      }).toList();
      return employees;
    } else {
      return [];
    }
  }
}
