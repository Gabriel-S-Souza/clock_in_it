import '../entities/user/user_entity.dart';

abstract class LocalStorageRepository {
  Future<bool> saveUser(UserEntity user);
  UserEntity? getUser();
  Future<bool> set({required String key, required String value});
  Future<bool> setList({required String key, required List<String> value});
  String? get(String key);
  List<String>? getList(String key);
  Future<bool> delete({required String key});
  Future<bool> deleteAll();
}
