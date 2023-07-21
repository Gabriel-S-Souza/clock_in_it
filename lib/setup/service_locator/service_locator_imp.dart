import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../shared/data/local_storage/local_storage.dart';
import '../../shared/data/local_storage/local_storage_imp.dart';
import '../../shared/data/secure_local_storage/secure_local_storage.dart';
import '../../shared/data/secure_local_storage/secure_local_storage_imp.dart';
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

    // local storage
    final localStorage = LocalStorageImp();
    await localStorage.init();
    registerFactory<LocalStorage>(() => localStorage);

    registerFactory<SecureLocalStorage>(() => SecureLocalStorageImp(const FlutterSecureStorage()));
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
