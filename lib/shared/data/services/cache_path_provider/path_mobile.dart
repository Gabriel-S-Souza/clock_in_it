import 'package:path_provider/path_provider.dart';

import 'path_base.dart';

class CachePathImp implements CachePathBase {
  @override
  Future<String> get path => getTemporaryDirectory().then((value) => value.path);
}
