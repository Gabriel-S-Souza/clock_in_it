import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class Cache {
  static final Cache I = Cache._internal();
  factory Cache() => I;
  Cache._internal();

  late final String _direcoryCachePath;
  static String get direcoryCachePath => I._direcoryCachePath;

  Cache init(String direcoryCachePath) {
    _direcoryCachePath = direcoryCachePath;
    return this;
  }

  static Future<File> getCacheFile(String key) async {
    final Directory cacheDirectory = Directory(direcoryCachePath);
    if (!cacheDirectory.existsSync()) {
      await cacheDirectory.create(recursive: true);
    }
    return File('${cacheDirectory.path}/$key');
  }

  static Future<void> saveData(String key, String data) async {
    final File cacheFile = await getCacheFile(key);
    await cacheFile.writeAsString(data);
  }

  static Future<String?> getData(String key) async {
    final File cacheFile = await getCacheFile(key);
    if (!cacheFile.existsSync()) {
      return null;
    }
    return cacheFile.readAsString();
  }

  static Future<void> deleteData(String key) async {
    final File cacheFile = await getCacheFile(key);
    if (cacheFile.existsSync()) {
      await cacheFile.delete();
    }
  }

  Future<void> setList(String employeesCacheKey, {required List<String> value}) async {
    final String json = jsonEncode(value);
    await Cache.saveData(employeesCacheKey, json);
    log('setList');
  }

  Future<List<dynamic>?> getList(String employeesCacheKey) async {
    final String? json = await Cache.getData(employeesCacheKey);
    if (json == null) {
      return null;
    }
    log('getList');
    return jsonDecode(json) as List;
  }
}
