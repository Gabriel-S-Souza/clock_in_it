import 'dart:convert';

import 'package:clock_in_it/features/employee/data/data_sources/cache/employee_cacheanle_data_source_imp.dart';
import 'package:clock_in_it/features/employee/data/models/employee_model.dart';
import 'package:clock_in_it/shared/domain/entities/failure/failure.dart';
import 'package:clock_in_it/shared/domain/entities/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes/employee_details_fake.dart';
import '../../../fakes/employee_fake.dart';
import '../../../mocks/build_mocks.mocks.dart';

void main() {
  late EmployeeCacheableDataSourceImp employeeCacheableDataSource;
  late MockEmployeeDataSource mockEmployeeDataSource;
  late MockLocalStorageDataSource mockLocalStorageDataSource;

  setUp(() {
    mockEmployeeDataSource = MockEmployeeDataSource();
    mockLocalStorageDataSource = MockLocalStorageDataSource();
    employeeCacheableDataSource = EmployeeCacheableDataSourceImp(
      employeeRemoteDataSource: mockEmployeeDataSource,
      localStorageDataSource: mockLocalStorageDataSource,
    );
  });

  group('EmployeeCacheableDataSourceImp.getEmployees |', () {
    test(
        'success: should return a Result with a list of EmployeeModel when the API call is successful and cache the result',
        () async {
      // Arrange
      when(mockEmployeeDataSource.getEmployees())
          .thenAnswer((_) async => Result.success(employeesFake));
      when(mockLocalStorageDataSource.setList('employees', value: anyNamed('value')))
          .thenAnswer((_) async => true);

      // Act
      final result = await employeeCacheableDataSource.getEmployees();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isA<List<EmployeeModel>>());

      verify(mockEmployeeDataSource.getEmployees()).called(1);
      verify(mockLocalStorageDataSource.setList('employees', value: anyNamed('value'))).called(1);
      verifyNoMoreInteractions(mockEmployeeDataSource);
      verifyNoMoreInteractions(mockLocalStorageDataSource);
    });

    test(
        'failure: should return a Result with a Failure and a cached list of EmployeeModel when the remote data source call fails',
        () async {
      // Arrange
      when(mockEmployeeDataSource.getEmployees()).thenAnswer(
          (realInvocation) => Future.value(Result.failure(const Failure('Failed to get'))));
      when(mockLocalStorageDataSource.getList('employees')).thenReturn(_stubEmployeesCache());

      // Act
      final result = await employeeCacheableDataSource.getEmployees();

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.cachedData, isA<List<EmployeeModel>>());

      verify(mockEmployeeDataSource.getEmployees()).called(1);
      verify(mockLocalStorageDataSource.getList('employees')).called(1);
      verifyNoMoreInteractions(mockEmployeeDataSource);
      verifyNoMoreInteractions(mockLocalStorageDataSource);
    });
  });

  group('EmployeeCacheableDataSourceImp.getDetails |', () {
    test('getDetails: should call employeeRemoteDataSource.getDetails with the correct employeeId',
        () async {
      // Arrange
      const employeeId = '1';

      when(mockEmployeeDataSource.getDetails(any))
          .thenAnswer((_) async => Result.success(employeeDetailsFake));

      // Act
      await employeeCacheableDataSource.getDetails(employeeId);

      // Assert
      verify(mockEmployeeDataSource.getDetails(employeeId)).called(1);
      verifyNoMoreInteractions(mockEmployeeDataSource);
    });
  });
}

List<String> _stubEmployeesCache() =>
    employeesFake.map((employee) => jsonEncode(employee.toJson())).toList();
