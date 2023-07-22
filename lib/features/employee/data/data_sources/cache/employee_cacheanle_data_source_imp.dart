import 'dart:convert';

import '../../../../../shared/data/data_sources/local_storage/local_storage_data_source.dart';
import '../../../../../shared/domain/entities/result/result.dart';
import '../../models/employee_detail_model.dart';
import '../../models/employee_model.dart';
import '../remote/employee_data_source.dart';
import 'employee_cacheable_data_source.dart';

class EmployeeCacheableDataSourceImp implements EmployeeCacheableDataSource {
  final EmployeeDataSource _employeeRemoteDataSource;
  final LocalStorageDataSource _localStorageDataSource;

  final String _employeesCacheKey = 'employees';

  EmployeeCacheableDataSourceImp({
    required EmployeeDataSource employeeRemoteDataSource,
    required LocalStorageDataSource localStorageDataSource,
  })  : _employeeRemoteDataSource = employeeRemoteDataSource,
        _localStorageDataSource = localStorageDataSource;

  @override
  Future<Result<List<EmployeeModel>>> getEmployees() async {
    final employeesResult = await _employeeRemoteDataSource.getEmployees();

    if (employeesResult.isSuccess) {
      _saveInCache(employeesResult.data);
      return employeesResult;
    } else {
      final List<EmployeeModel> cachedEmployees = _getFromCache();
      return Result.failure(employeesResult.failure, cachedEmployees);
    }
  }

  @override
  Future<Result<EmployeeDetailModel>> getDetails(String employeeId) =>
      _employeeRemoteDataSource.getDetails(employeeId);

  void _saveInCache(List<EmployeeModel> employees) {
    final employeesJson = employees.map((employee) => jsonEncode(employee.toJson())).toList();
    _localStorageDataSource.setList(_employeesCacheKey, value: employeesJson);
  }

  List<EmployeeModel> _getFromCache() {
    final employeesJson = _localStorageDataSource.getList(_employeesCacheKey);
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
