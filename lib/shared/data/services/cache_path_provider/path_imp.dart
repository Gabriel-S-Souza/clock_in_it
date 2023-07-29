import './path_stub.dart'
    if (dart.library.html) './path_web.dart'
    if (dart.library.io) './path_mobile.dart';
import 'path_base.dart';

class TempPath implements CachePathBase {
  @override
  Future<String> get path => CachePathImp().path;
}
