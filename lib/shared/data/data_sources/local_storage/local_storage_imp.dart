import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage.dart';

class LocalStorageImp implements LocalStorage {
  late final SharedPreferences _prefs;

  Future<void> init([SharedPreferences? prefs]) async {
    _prefs = prefs ?? await SharedPreferences.getInstance();
  }

  @override
  List<String>? getList(String key) => _prefs.getStringList(key);

  @override
  Future<bool> setList({required String key, required List<String> value}) =>
      _prefs.setStringList(key, value);

  @override
  Future<bool> delete({required String key}) => _prefs.remove(key);

  @override
  Future<bool> deleteAll() => _prefs.clear();

  @override
  String? get(String key) => _prefs.getString(key);

  @override
  Future<bool> set({required String key, required String value}) async =>
      _prefs.setString(key, value);
}
