import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_local_storage.dart';

class SecureLocalStorageImp implements SecureLocalStorage {
  final FlutterSecureStorage _storage;
  final options = const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  SecureLocalStorageImp(this._storage);

  @override
  Future<String?> get(String key) async {
    try {
      final res = await _storage.read(key: key);
      return res;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> set(String key, String value) =>
      _storage.write(key: key, value: value, iOptions: options);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
