import '../../../../../shared/domain/entities/result/result.dart';
import '../../models/employee_model.dart';
import '../remote/employee_data_source.dart';

abstract class EmployeeCacheableDataSource implements EmployeeDataSource {
  final EmployeeDataSource _employeeRemoteDataSource;

  EmployeeCacheableDataSource(this._employeeRemoteDataSource);

  @override
  Future<Result<List<EmployeeModel>>> getEmployees() => _employeeRemoteDataSource.getEmployees();
}
