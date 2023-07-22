import '../../../../../shared/domain/entities/result/result.dart';
import '../../models/employee_detail_model.dart';
import '../../models/employee_model.dart';

abstract class EmployeeDataSource {
  Future<Result<List<EmployeeModel>>> getEmployees();
  Future<Result<EmployeeDetailModel>> getDetails(String employeeId);
}
