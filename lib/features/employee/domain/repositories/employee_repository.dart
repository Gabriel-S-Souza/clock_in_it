import '../../../../shared/domain/entities/result/result.dart';
import '../entities/employee_details_entity.dart';
import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<Result<List<EmployeeEntity>>> getEmployees();
  Future<Result<EmployeeDetailsEntity>> getDetails(String employeeId);
}
