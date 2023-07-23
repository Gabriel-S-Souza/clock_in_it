import 'package:clock_in_it/features/auth/data/data_sources/auth_datasource.dart';
import 'package:clock_in_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:clock_in_it/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:clock_in_it/features/auth/presentation/blocs/login_bloc.dart';
import 'package:clock_in_it/features/employee/data/data_sources/cache/employee_cacheable_data_source.dart';
import 'package:clock_in_it/features/employee/data/data_sources/remote/employee_data_source.dart';
import 'package:clock_in_it/features/employee/domain/repositories/employee_repository.dart';
import 'package:clock_in_it/features/employee/domain/use_cases/employee_use_case.dart';
import 'package:clock_in_it/setup/http/http_client.dart';
import 'package:clock_in_it/shared/data/data_sources/local_storage/local_storage_data_source.dart';
import 'package:clock_in_it/shared/data/data_sources/secure_local_storage/secure_local_storage.dart';
import 'package:clock_in_it/shared/domain/repositories/local_storage_repository.dart';
import 'package:clock_in_it/shared/domain/use_cases/local_storage_use_case.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  HttpClient,
  SecureLocalStorage,
  LocalStorageDataSource,
  LocalStorageRepository,
  LocalStorageUseCase,
  AuthDataSource,
  AuthRepository,
  AuthUseCase,
  LoginBloc,
  EmployeeDataSource,
  EmployeeCacheableDataSource,
  EmployeeRepository,
  EmployeeUseCase,
])
void main() {}
