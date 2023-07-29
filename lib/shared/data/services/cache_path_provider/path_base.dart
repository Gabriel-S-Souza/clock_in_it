// Usado para pegar o caminho da pasta temporária do dispositivo móveis e evitar no navegador
abstract class CachePathBase {
  Future<String> get path;
}
