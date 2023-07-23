import 'package:clock_in_it/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:clock_in_it/shared/domain/entities/failure/failure.dart';
import 'package:clock_in_it/shared/domain/entities/result/result.dart';
import 'package:clock_in_it/shared/domain/entities/user/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes/credentials_fake.dart';
import '../../../mocks/build_mocks.mocks.dart';

void main() {
  late AuthRepositoryImp authRepository;
  late MockAuthDataSource mockAuthDataSource;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    authRepository = AuthRepositoryImp(mockAuthDataSource);
  });

  group('AuthRepositoryImp.login |', () {
    test(
        'success: should return a Result with a UserEntity when the datasource returns a successful response',
        () async {
      // Arrange
      final user = UserEntity(id: 1, name: 'John Doe');

      final Matcher isValidUser = isA<UserEntity>()
          .having((user) => user.id, 'id', isA<int>())
          .having((user) => user.name, 'name', isA<String>());

      when(mockAuthDataSource.login(any)).thenAnswer((_) async => Result.success(user));

      // Act
      final result = await authRepository.login(credentialsEntityFake);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isValidUser);

      verify(mockAuthDataSource.login(any)).called(1);
      verifyNoMoreInteractions(mockAuthDataSource);
    });

    test(
        'failue: should return a Result with a Failure when the datasource returns an unsuccessful response',
        () async {
      // Arrange
      const String errorMessage = 'Failed to login';

      when(mockAuthDataSource.login(any))
          .thenAnswer((_) async => Result.failure(const Failure(errorMessage)));

      // Act
      final result = await authRepository.login(credentialsEntityFake);

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<Failure>());
      expect(result.failure.message, isA<String>());

      verify(mockAuthDataSource.login(any)).called(1);
      verifyNoMoreInteractions(mockAuthDataSource);
    });
  });
}
