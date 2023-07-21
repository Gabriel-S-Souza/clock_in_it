abstract class SecureLocalStorage {
  Future<void> set(String key, String value);
  Future<String?> get(String key);
  Future<void> delete(String key);
}
