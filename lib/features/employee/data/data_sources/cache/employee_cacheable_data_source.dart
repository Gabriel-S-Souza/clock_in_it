import '../../../../../shared/domain/entities/result/result.dart';
import '../../models/employee_detail_model.dart';
import '../../models/employee_model.dart';
import '../remote/employee_data_source.dart';

abstract class EmployeeCacheableDataSource implements EmployeeDataSource {
  final EmployeeDataSource _employeeRemoteDataSource;

  EmployeeCacheableDataSource({
    required EmployeeDataSource employeeRemoteDataSource,
  }) : _employeeRemoteDataSource = employeeRemoteDataSource;

  @override
  Future<Result<List<EmployeeModel>>> getEmployees() => _employeeRemoteDataSource.getEmployees();

  @override
  Future<Result<EmployeeDetailsModel>> getDetails(String employeeId) =>
      _employeeRemoteDataSource.getDetails(employeeId);
}
