import '../../../../../setup/http/http_client.dart';
import '../../../../../setup/utils/api_paths.dart';
import '../../../../../shared/data/data_sources/secure_local_storage/secure_local_storage.dart';
import '../../../../../shared/domain/entities/failure/failure.dart';
import '../../../../../shared/domain/entities/result/result.dart';
import '../../models/employee_detail_model.dart';
import '../../models/employee_model.dart';
import 'employee_data_source.dart';

class EmployeeDataSourceImp implements EmployeeDataSource {
  final HttpClient _httpClient;
  final SecureLocalStorage _secureLocalStorage;

  EmployeeDataSourceImp({
    required HttpClient httpClient,
    required SecureLocalStorage secureLocalStorage,
  })  : _httpClient = httpClient,
        _secureLocalStorage = secureLocalStorage;

  @override
  Future<Result<List<EmployeeModel>>> getEmployees() async {
    try {
      final response = await _httpClient.get(
        ApiPaths.employees,
        token: await _secureLocalStorage.get('accessToken'),
      );
      if (response.isSuccess) {
        final employees = (response.data as List).map((e) => EmployeeModel.fromJson(e)).toList();
        return Result.success(employees);
      } else {
        return Result.failure(const ServerFailure());
      }
    } on Failure catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(UnmappedFailure(e.toString()));
    }
  }

  @override
  Future<Result<EmployeeDetailsModel>> getDetails(String employeeId) async {
    try {
      final response = await _httpClient.get(
        '/${ApiPaths.employees}/$employeeId',
        token: await _secureLocalStorage.get('accessToken'),
      );
      if (response.isSuccess) {
        final employee = EmployeeDetailsModel.fromJson(response.data);
        return Result.success(employee);
      } else {
        return Result.failure(const ServerFailure());
      }
    } on Failure catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(UnmappedFailure(e.toString()));
    }
  }
}
