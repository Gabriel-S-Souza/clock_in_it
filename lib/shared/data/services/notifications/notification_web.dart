// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math' as math;

import '../../../../features/employee/data/models/employee_model.dart';
import '../../../../setup/service_locator/service_locator_imp.dart';
import '../../../domain/repositories/local_storage_repository.dart';
import 'notification_base.dart';

class NotificationService implements NotificationServiceBase {
  final LocalStorageRepository _localStorage = ServiceLocatorImp.I.get<LocalStorageRepository>();
  bool _showPeriodicNotification = false;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> show(int id, String title, [String? body]) async {
    var permission = Notification.permission;
    if (permission != 'granted') {
      permission = await Notification.requestPermission();
    }
    if (permission == 'granted') {
      Notification(title, body: body);
    }
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
