import 'package:bloc_test/bloc_test.dart';
import 'package:clock_in_it/features/auth/presentation/blocs/login_bloc.dart';
import 'package:clock_in_it/features/auth/presentation/blocs/login_state.dart';
import 'package:clock_in_it/shared/domain/entities/failure/failure.dart';
import 'package:clock_in_it/shared/domain/entities/result/result.dart';
import 'package:clock_in_it/shared/domain/entities/user/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/build_mocks.mocks.dart';

void main() {
  late LoginBloc loginBloc;
  late MockAuthUseCase mockAuthUseCase;
  late MockLocalStorageUseCase mockLocalStorageUseCase;

  setUp(() {
    mockAuthUseCase = MockAuthUseCase();
    mockLocalStorageUseCase = MockLocalStorageUseCase();
    loginBloc = LoginBloc(
      authUseCase: mockAuthUseCase,
      localStorage: mockLocalStorageUseCase,
    );
  });

  group('LoginBloc |', () {
    test('initial: should have the correct initial state', () {
      expect(loginBloc.state, isA<LoginInitial>());
    });

    blocTest<LoginBloc, LoginState>(
      'success: should emit LoginLoading and then LoginSuccess having the logged user when AuthUseCase.login is called and succeeds',
      // Arrange
      build: () {
        when(mockAuthUseCase.login(any))
            .thenAnswer((_) async => Result.success(UserEntity(id: 1, name: 'John Doe')));
        when(mockLocalStorageUseCase.saveUser(any)).thenAnswer((_) async => true);
        return loginBloc;
      },
      // Act
      act: (bloc) => bloc.login('Jhon Doe', '123456'),
      // Assert
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>().having((state) => state.user, 'user', isA<UserEntity>()),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'failure: should emit LoginLoading and then LoginError with the failure message when AuthUseCase.login fails',
      // Arrange
      build: () {
        when(mockAuthUseCase.login(any))
            .thenAnswer((_) async => Result.failure(const Failure('Failed to login')));
        return loginBloc;
      },
      // Act
      act: (bloc) => bloc.login('Jhon Doe', '123456'),
      // Assert
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginError>().having((state) => state.message, 'message', 'Failed to login'),
      ],
    );
  });
}
