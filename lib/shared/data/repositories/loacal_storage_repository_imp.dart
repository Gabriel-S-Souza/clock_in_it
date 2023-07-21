import 'dart:convert';

import '../models/user/user_model.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/local_storage_repository.dart';
import '../data_sources/local_storage/local_storage.dart';

class LocalStorageRepositoryImp implements LocalStorageRepository {
  final LocalStorage _localStorageDataSource;

  LocalStorageRepositoryImp(this._localStorageDataSource);

  @override
  Future<bool> delete({required String key}) => _localStorageDataSource.delete(key: key);

  @override
  Future<bool> deleteAll() => _localStorageDataSource.deleteAll();

  @override
  String? get(String key) => _localStorageDataSource.get(key);

  @override
  List<String>? getList(String key) => _localStorageDataSource.getList(key);

  @override
  Future<bool> saveUser(UserEntity user) => _localStorageDataSource.set(
        key: 'user',
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
  Future<bool> set({required String key, required String value}) =>
      _localStorageDataSource.set(key: key, value: value);

  @override
  Future<bool> setList({required String key, required List<String> value}) =>
      _localStorageDataSource.setList(key: key, value: value);
}
