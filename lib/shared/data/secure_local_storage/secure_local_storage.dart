abstract class SecureLocalStorage {
  Future<void> set({required String key, required String value});
  Future<String?> get(String key);
  Future<void> delete(String key);
}
