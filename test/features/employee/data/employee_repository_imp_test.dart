import 'package:clock_in_it/features/employee/data/repositories/employee_repository_imp.dart';
import 'package:clock_in_it/features/employee/domain/entities/employee_details_entity.dart';
import 'package:clock_in_it/features/employee/domain/entities/employee_entity.dart';
import 'package:clock_in_it/features/employee/domain/repositories/employee_repository.dart';
import 'package:clock_in_it/shared/domain/entities/failure/failure.dart';
import 'package:clock_in_it/shared/domain/entities/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes/employee_details_fake.dart';
import '../../../fakes/employee_fake.dart';
import '../../../mocks/build_mocks.mocks.dart';

void main() {
  late EmployeeRepository repository;
  late MockEmployeeDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockEmployeeDataSource();
    repository = EmployeeRepositoryImp(mockDataSource);
  });

  group('EmployeeRepositoryImp.getEmployees |', () {
    test('success: should return a Result with a List<EmployeeEntity>', () async {
      // Arrange
      when(mockDataSource.getEmployees()).thenAnswer((_) async => Result.success(employeesFake));

      // Act
      final result = await repository.getEmployees();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isA<List<EmployeeEntity>>());

      verify(mockDataSource.getEmployees()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test(
        'failure: should return a Result with a Failure when the response of the repository is unsuccessful',
        () async {
      // Arrange
      const String errorMessage = 'Failed to get employees';

      when(mockDataSource.getEmployees())
          .thenAnswer((_) async => Result.failure(const Failure(errorMessage)));

      // Act
      final result = await repository.getEmployees();

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<Failure>());
      expect(result.failure.message, isA<String>());

      verify(mockDataSource.getEmployees()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('EmployeeRepositoryImp.getDetails |', () {
    test('success: should return a Result with a EmployeeDetailsEntity', () async {
// Arrange
      const employeeId = '123456';

      when(mockDataSource.getDetails(employeeId))
          .thenAnswer((_) async => Result.success(employeeDetailsFake));

      // Act
      final result = await repository.getDetails(employeeId);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isA<EmployeeDetailsEntity>());

      verify(mockDataSource.getDetails(employeeId)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test(
        'failure: should return a Result with a Failure when the response of the repository is unsuccessful',
        () async {
      // Arrange
      const String errorMessage = 'Failed to get employee details';
      const employeeId = '123456';

      when(mockDataSource.getDetails(employeeId))
          .thenAnswer((_) async => Result.failure(const Failure(errorMessage)));

      // Act
      final result = await repository.getDetails(employeeId);

      // Assert
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<Failure>());
      expect(result.failure.message, isA<String>());

      verify(mockDataSource.getDetails(employeeId)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
