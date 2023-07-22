import '../../../../shared/domain/entities/result/result.dart';
import '../../domain/entities/employee_detail_entity.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../data_sources/remote/employee_data_source.dart';

class EmployeeRepositoryImp implements EmployeeRepository {
  final EmployeeDataSource _employeeDataSource;

  const EmployeeRepositoryImp(this._employeeDataSource);

  @override
  Future<Result<List<EmployeeEntity>>> getEmployees() => _employeeDataSource.getEmployees();

  @override
  Future<Result<EmployeeDetailEntity>> getDetails(String employeeId) =>
      _employeeDataSource.getDetails(employeeId);
}
