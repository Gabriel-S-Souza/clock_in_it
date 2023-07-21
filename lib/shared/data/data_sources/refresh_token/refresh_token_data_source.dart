import '../../../domain/entities/result/result.dart';
import '../../models/auth/auth_model.dart';

abstract class RefreshTokenDataSource {
  Future<Result<AuthModel>> call();
}
