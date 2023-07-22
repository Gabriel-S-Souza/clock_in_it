abstract class LocalStorageDataSource {
  Future<bool> set(String key, {required String value});
  Future<bool> setList(String key, {required List<String> value});
  String? get(String key);
  List<String>? getList(String key);
  Future<bool> delete(String key);
  Future<bool> deleteAll();
}
