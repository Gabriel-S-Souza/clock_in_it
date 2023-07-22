import 'package:clock_in_it/features/auth/domain/entities/login_credentials_entity.dart';
import 'package:clock_in_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:clock_in_it/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:clock_in_it/shared/domain/entities/failure/failure.dart';
import 'package:clock_in_it/shared/domain/entities/result/result.dart';
import 'package:clock_in_it/shared/domain/entities/user/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/auth_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late AuthUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = AuthUseCaseImp(mockRepository);
  });

  group('AuthUseCase.login |', () {
    test('success: should return a Result with a UserEntity', () async {
      // Arrange
      final credentials = LoginCredentialsEntity(username: 'John Doe', password: '123456');
      final user = UserEntity(id: 1, name: 'John Doe');

      final Matcher isValidUser = isA<UserEntity>()
          .having((user) => user.id, 'id', isA<int>())
          .having((user) => user.name, 'name', isA<String>());

      when(mockRepository.login(credentials)).thenAnswer((_) async => Result.success(user));

      // Act
      final result = await useCase.login(credentials);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isValidUser);

      verify(mockRepository.login(credentials)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'failure: should return a Result with a Failure when the response of the repository is unsuccessful',
        () async {
      // Arrange
      const String errorMessage = 'Failed to login';
      final credentials = LoginCredentialsEntity(username: 'John Doe', password: '123456');

      when(mockRepository.login(credentials))
          .thenAnswer((_) async => Result.failure(const Failure(errorMessage)));

      // Act
      final result = await useCase.login(credentials);

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<Failure>());
      expect(result.failure.message, isA<String>());

      verify(mockRepository.login(credentials)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
