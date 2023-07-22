import '../../../../shared/domain/entities/result/result.dart';
import '../entities/employee_details_entity.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

abstract class EmployeeUseCase {
  Future<Result<List<EmployeeEntity>>> getEmployees();
  Future<Result<EmployeeDetailsEntity>> getDetails(String employeeId);
}

class EmployeeUseCaseImp implements EmployeeUseCase {
  final EmployeeRepository _employeeRepository;

  const EmployeeUseCaseImp(this._employeeRepository);

  @override
  Future<Result<List<EmployeeEntity>>> getEmployees() => _employeeRepository.getEmployees();

  @override
  Future<Result<EmployeeDetailsEntity>> getDetails(String employeeId) =>
      _employeeRepository.getDetails(employeeId);
}
