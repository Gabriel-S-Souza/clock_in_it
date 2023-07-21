import '../../../domain/entities/result/result.dart';

abstract class RefreshTokenDataSource {
  Future<VoidSuccess> call();
}
