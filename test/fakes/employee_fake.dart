import 'package:clock_in_it/features/employee/data/models/employee_model.dart';

import '../fixtures/employees_fixture.dart';

final List<EmployeeModel> employeesFake = employeesFixture
    .map<EmployeeModel>((employeeJson) => EmployeeModel.fromJson(employeeJson))
    .toList();
