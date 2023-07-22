import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/data_sources/auth_datasource.dart';
import '../../features/auth/data/data_sources/auth_datasource_imp.dart';
import '../../features/auth/data/repositories/auth_repository_imp.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/auth_use_case.dart';
import '../../features/auth/presentation/blocs/login_bloc.dart';
import '../../features/employee/data/data_sources/employee_data_source.dart';
import '../../features/employee/data/data_sources/employee_data_source_imp.dart';
import '../../features/employee/data/repositories/employee_repository_imp.dart';
import '../../features/employee/domain/repositories/employee_repository.dart';
import '../../features/employee/domain/use_cases/employee_use_case.dart';
import '../../features/employee/presentation/blocs/employees/employees_bloc.dart';
import '../../shared/data/data_sources/local_storage/local_storage_data_source.dart';
import '../../shared/data/data_sources/local_storage/local_storage_data_source_imp.dart';
import '../../shared/data/data_sources/refresh_token/refresh_token_data_source.dart';
import '../../shared/data/data_sources/refresh_token/refresh_token_data_source_imp.dart';
import '../../shared/data/data_sources/secure_local_storage/secure_local_storage.dart';
import '../../shared/data/data_sources/secure_local_storage/secure_local_storage_imp.dart';
import '../../shared/data/repositories/loacal_storage_repository_imp.dart';
import '../../shared/domain/repositories/local_storage_repository.dart';
import '../../shared/domain/use_cases/local_storage_use_case.dart';
import '../http/dio_app.dart';
import '../http/http_client.dart';
import 'service_locator.dart';

class ServiceLocatorImp implements ServiceLocator {
  static final ServiceLocatorImp I = ServiceLocatorImp._internal();

  late final GetIt _getIt;

  ServiceLocatorImp._internal();

  factory ServiceLocatorImp([GetIt? getIt]) {
    I._getIt = getIt ?? GetIt.instance;
    return I;
  }

  @override
  Future<void> setup() async {
    // http
    registerFactory<HttpClient>(() => HttpClient(dioApp));

    // data sources
    final localStorage = LocalStorageDataSourceImp();
    await localStorage.init();
    registerFactory<LocalStorageDataSource>(() => localStorage);

    registerFactory<SecureLocalStorage>(() => SecureLocalStorageImp(const FlutterSecureStorage()));

    registerFactory<AuthDataSource>(() => AuthDataSourceImp(
          httpClient: get(),
          secureLocalStorage: get(),
        ));

    registerFactory<RefreshTokenDataSource>(() => RefreshTokenDataSourceImp(
          httpClient: get(),
          secureLocalStorage: get(),
        ));

    registerFactory<EmployeeDataSource>(() => EmployeeDataSourceImp(
          httpClient: get(),
          secureLocalStorage: get(),
        ));

    // repositories
    registerFactory<LocalStorageRepository>(() => LocalStorageRepositoryImp(get()));

    registerFactory<AuthRepository>(() => AuthRepositoryImp(get()));

    registerFactory<EmployeeRepository>(() => EmployeeRepositoryImp(get()));

    // use cases
    registerFactory<LocalStorageUseCase>(() => LocalStorageUseCaseImp(get()));

    registerFactory<AuthUseCase>(() => AuthUseCaseImp(get()));

    registerFactory<EmployeeUseCase>(() => EmployeeUseCaseImp(get()));

    // blocs
    registerFactory<LoginBloc>(() => LoginBloc(
          authUseCase: get(),
          localStorage: get(),
        ));

    registerFactory<EmployeesBloc>(() => EmployeesBloc(
          employeeUseCase: get(),
          localStorageUseCase: get(),
        ));
  }

  @override
  T get<T extends Object>() => _getIt.get<T>();

  @override
  void registerFactory<T extends Object>(T Function() factory) {
    _getIt.registerFactory<T>(factory);
  }

  @override
  void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  @override
  bool isRegistered<T extends Object>() => _getIt.isRegistered<T>();
}
