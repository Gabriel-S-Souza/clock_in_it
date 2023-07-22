import 'dart:convert';

import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/local_storage_repository.dart';
import '../data_sources/local_storage/local_storage_data_source.dart';
import '../models/user/user_model.dart';

class LocalStorageRepositoryImp implements LocalStorageRepository {
  final LocalStorageDataSource _localStorageDataSource;

  LocalStorageRepositoryImp(this._localStorageDataSource);

  @override
  Future<bool> delete(String key) => _localStorageDataSource.delete(key);

  @override
  Future<bool> deleteAll() => _localStorageDataSource.deleteAll();

  @override
  String? get(String key) => _localStorageDataSource.get(key);

  @override
  List<String>? getList(String key) => _localStorageDataSource.getList(key);

  @override
  Future<bool> saveUser(UserEntity user) => _localStorageDataSource.set(
        'user',
        value: jsonEncode({
          'id': user.id,
          'username': user.name,
        }),
      );

  @override
  UserEntity? getUser() {
    final user = _localStorageDataSource.get('user');
    if (user != null) {
      final userMap = jsonDecode(user);
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  @override
  Future<bool> set(String key, {required String value}) =>
      _localStorageDataSource.set(key, value: value);

  @override
  Future<bool> setList(String key, {required List<String> value}) =>
      _localStorageDataSource.setList(key, value: value);
}
