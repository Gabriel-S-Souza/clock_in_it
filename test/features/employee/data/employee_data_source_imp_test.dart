import 'package:clock_in_it/features/employee/data/data_sources/remote/employee_data_source.dart';
import 'package:clock_in_it/features/employee/data/data_sources/remote/employee_data_source_imp.dart';
import 'package:clock_in_it/features/employee/data/models/employee_detail_model.dart';
import 'package:clock_in_it/features/employee/data/models/employee_model.dart';
import 'package:clock_in_it/shared/domain/entities/failure/failure.dart';
import 'package:clock_in_it/shared/domain/entities/response/response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/employee_details_fixture.dart';
import '../../../fixtures/employees_fixture.dart';
import '../../../mocks/build_mocks.mocks.dart';

void main() {
  late EmployeeDataSource employeeDataSource;
  late MockHttpClient mockHttpClient;
  late MockSecureLocalStorage mockSecureLocalStorage;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSecureLocalStorage = MockSecureLocalStorage();
    employeeDataSource = EmployeeDataSourceImp(
      httpClient: mockHttpClient,
      secureLocalStorage: mockSecureLocalStorage,
    );
  });

  group('EmployeeDataSourceImp.getEmployees |', () {
    test(
        'success: should return a Result with a list of EmployeeModel when the API call is successful',
        () async {
      // Arrange
      final response = ResponseApp(data: employeesFixture, statusCode: 200);

      when(mockHttpClient.get(any, token: anyNamed('token'))).thenAnswer((_) async => response);
      when(mockSecureLocalStorage.get('accessToken')).thenAnswer((_) async => 'fake_access_token');

      // Act
      final result = await employeeDataSource.getEmployees();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isA<List<EmployeeModel>>());

      verify(mockHttpClient.get(any, token: 'fake_access_token')).called(1);
      verify(mockSecureLocalStorage.get('accessToken')).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });

    test(
        'failure: should return a Result with a ServerFailure when the API call the status code is not in the range of 200-299',
        () async {
      // Arrange
      final response = ResponseApp(data: null, statusCode: 500);

      when(mockHttpClient.get(any, token: anyNamed('token'))).thenAnswer((_) async => response);
      when(mockSecureLocalStorage.get('accessToken')).thenAnswer((_) async => 'fake_access_token');

      // Act
      final result = await employeeDataSource.getEmployees();

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<ServerFailure>());

      verify(mockHttpClient.get(any, token: 'fake_access_token')).called(1);
      verify(mockSecureLocalStorage.get('accessToken')).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });

    test('failure: should return a Result with a Failure when the http client throws a Failure',
        () async {
      // Arrange
      when(mockHttpClient.get(any, token: anyNamed('token'))).thenThrow(const Failure('Failed'));
      when(mockSecureLocalStorage.get('accessToken')).thenAnswer((_) async => 'fake_access_token');

      // Act
      final result = await employeeDataSource.getEmployees();

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<Failure>());

      verify(mockHttpClient.get(any, token: 'fake_access_token')).called(1);
      verify(mockSecureLocalStorage.get('accessToken')).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });

    test('failure: should return a Result with an UnmappedFailure when an unexpected error occurs',
        () async {
      // Arrange
      const errorMessage = 'Unexpected error';
      when(mockHttpClient.get(any, token: anyNamed('token'))).thenThrow(errorMessage);
      when(mockSecureLocalStorage.get('accessToken')).thenAnswer((_) async => 'fake_access_token');

      // Act
      final result = await employeeDataSource.getEmployees();

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<UnmappedFailure>());
      expect(result.failure.message, equals(errorMessage));

      verify(mockHttpClient.get(any, token: 'fake_access_token')).called(1);
      verify(mockSecureLocalStorage.get('accessToken')).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });
  });

  group('EmployeeDataSourceImp.getDetails |', () {
    test(
        'success: should return a Result with an EmployeeDetailsModel when the API call is successful',
        () async {
      // Arrange
      final response = ResponseApp(data: employeeDetailsFixture, statusCode: 200);

      when(mockHttpClient.get(any, token: anyNamed('token'))).thenAnswer((_) async => response);
      when(mockSecureLocalStorage.get('accessToken')).thenAnswer((_) async => 'fake_access_token');

      // Act
      final result = await employeeDataSource.getDetails('1');

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isA<EmployeeDetailsModel>());

      verify(mockHttpClient.get(any, token: 'fake_access_token')).called(1);
      verify(mockSecureLocalStorage.get('accessToken')).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });

    test(
        'failure: should return a Result with a ServerFailure when the status code is not in the range of 200-299',
        () async {
      // Arrange
      final response = ResponseApp(data: null, statusCode: 500);

      when(mockHttpClient.get(any, token: anyNamed('token'))).thenAnswer((_) async => response);
      when(mockSecureLocalStorage.get('accessToken')).thenAnswer((_) async => 'fake_access_token');

      // Act
      final result = await employeeDataSource.getDetails('1');

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<ServerFailure>());

      verify(mockHttpClient.get(any, token: 'fake_access_token')).called(1);
      verify(mockSecureLocalStorage.get('accessToken')).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });

    test('failure: should return a Result with a Failure http client throws a Failure', () async {
      // Arrange
      const errorMessage = 'Unexpected error';
      when(mockHttpClient.get(any, token: anyNamed('token')))
          .thenThrow(const Failure(errorMessage));
      when(mockSecureLocalStorage.get('accessToken')).thenAnswer((_) async => 'fake_access_token');

      // Act
      final result = await employeeDataSource.getDetails('1');

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<Failure>());
      expect(result.failure.message, equals(errorMessage));

      verify(mockHttpClient.get(any, token: 'fake_access_token')).called(1);
      verify(mockSecureLocalStorage.get('accessToken')).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });

    test('failure: should return a Result with an UnmappedFailure when an unexpected error occurs',
        () async {
      // Arrange
      const errorMessage = 'Unexpected error';
      when(mockHttpClient.get(any, token: anyNamed('token'))).thenThrow(errorMessage);
      when(mockSecureLocalStorage.get('accessToken')).thenAnswer((_) async => 'fake_access_token');

      // Act
      final result = await employeeDataSource.getDetails('1');

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<UnmappedFailure>());
      expect(result.failure.message, equals(errorMessage));

      verify(mockHttpClient.get(any, token: 'fake_access_token')).called(1);
      verify(mockSecureLocalStorage.get('accessToken')).called(1);
      verifyNoMoreInteractions(mockHttpClient);
      verifyNoMoreInteractions(mockSecureLocalStorage);
    });
  });
}
