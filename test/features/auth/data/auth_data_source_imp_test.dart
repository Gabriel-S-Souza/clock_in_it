import 'package:clock_in_it/features/auth/data/data_sources/auth_datasource_imp.dart';
import 'package:clock_in_it/shared/domain/entities/failure/failure.dart';
import 'package:clock_in_it/shared/domain/entities/response/response.dart';
import 'package:clock_in_it/shared/domain/entities/user/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../fakes/credentials_fake.dart';
import '../../../fixtures/login_fixture.dart';
import '../../../mocks/build_mocks.mocks.dart';

void main() {
  late AuthDataSourceImp authDataSource;
  late MockHttpClient mockHttpClient;
  late MockSecureLocalStorage mockSecureLocalStorage;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSecureLocalStorage = MockSecureLocalStorage();
    authDataSource = AuthDataSourceImp(
      httpClient: mockHttpClient,
      secureLocalStorage: mockSecureLocalStorage,
    );
  });

  group('AuthDataSourceImp.login |', () {
    test(
        'success: should return a Result with a UserEntity when the API call is successful and should save the tokens in the secure local storage',
        () async {
      // Arrange
      final response = ResponseApp(data: loginFixture, statusCode: 200);

      final Matcher isValidUser = isA<UserEntity>()
          .having((user) => user.id, 'id', isA<int>())
          .having((user) => user.name, 'name', isA<String>());

      when(mockHttpClient.post(any, body: credentialsModelFake.toJson()))
          .thenAnswer((_) async => response);

      // Act
      final result = await authDataSource.login(credentialsModelFake);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isValidUser);

      verify(mockHttpClient.post(any, body: credentialsModelFake.toJson())).called(1);
      verify(mockSecureLocalStorage.set('accessToken', any)).called(1);
      verify(mockSecureLocalStorage.set('refreshToken', any)).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });

    test('failure: should return a Result with a ServerFailure when the API call is unsuccessful',
        () async {
      // Arrange
      final response = ResponseApp(data: null, statusCode: 500);

      when(mockHttpClient.post(any, body: credentialsModelFake.toJson()))
          .thenAnswer((_) async => response);

      // Act
      final result = await authDataSource.login(credentialsModelFake);

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<ServerFailure>());

      verify(mockHttpClient.post(any, body: credentialsModelFake.toJson())).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });

    test('failure: should return a Result with a Failure when a Failure exception is caught',
        () async {
      // Arrange
      const failure = Failure('Failed to login');
      when(mockHttpClient.post(any, body: credentialsModelFake.toJson())).thenThrow(failure);

      // Act
      final result = await authDataSource.login(credentialsModelFake);

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<Failure>());

      verify(mockHttpClient.post(any, body: credentialsModelFake.toJson())).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });

    test('failure: should return a Result with a UnmappedFailure when an unexpected error occurs',
        () async {
      // Arrange
      final unexpectedException = Exception('Unexpected error');
      when(mockHttpClient.post(any, body: credentialsModelFake.toJson()))
          .thenThrow(unexpectedException);

      // Act
      final result = await authDataSource.login(credentialsModelFake);

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<UnmappedFailure>());
      expect(result.failure.message, isA<String>());

      verify(mockHttpClient.post(any, body: credentialsModelFake.toJson())).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });
  });
}
