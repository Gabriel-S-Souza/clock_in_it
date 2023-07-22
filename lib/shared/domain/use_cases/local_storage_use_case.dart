import '../entities/user/user_entity.dart';
import '../repositories/local_storage_repository.dart';

abstract class LocalStorageUseCase {
  Future<bool> saveUser(UserEntity user);
  UserEntity? getUser();
  Future<bool> set(String key, {required String value});
  Future<bool> setList(String key, {required List<String> value});
  String? get(String key);
  List<String>? getList(String key);
  Future<bool> delete(String key);
  Future<bool> deleteAll();
}

class LocalStorageUseCaseImp implements LocalStorageUseCase {
  final LocalStorageRepository _repository;

  LocalStorageUseCaseImp(this._repository);

  @override
  Future<bool> saveUser(UserEntity user) async => _repository.saveUser(user);

  @override
  UserEntity? getUser() => _repository.getUser();

  @override
  Future<bool> set(String key, {required String value}) async => _repository.set(key, value: value);

  @override
  Future<bool> setList(String key, {required value}) async =>
      _repository.setList(key, value: value);

  @override
  String? get(String key) => _repository.get(key);

  @override
  List<String>? getList(String key) => _repository.getList(key);

  @override
  Future<bool> delete(String key) async => _repository.delete(key);

  @override
  Future<bool> deleteAll() async => _repository.deleteAll();
}
