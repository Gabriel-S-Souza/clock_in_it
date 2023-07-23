import 'package:bloc_test/bloc_test.dart';
import 'package:clock_in_it/features/employee/presentation/blocs/employees/employees_bloc.dart';
import 'package:clock_in_it/features/employee/presentation/blocs/employees/employees_state.dart';
import 'package:clock_in_it/shared/domain/entities/failure/failure.dart';
import 'package:clock_in_it/shared/domain/entities/result/result.dart';
import 'package:clock_in_it/shared/domain/entities/user/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes/employee_fake.dart';
import '../../../mocks/build_mocks.mocks.dart';

void main() {
  late EmployeesBloc employeesBloc;
  late MockEmployeeUseCase mockEmployeeUseCase;
  late MockLocalStorageUseCase mockLocalStorageUseCase;

  setUp(() {
    mockEmployeeUseCase = MockEmployeeUseCase();
    mockLocalStorageUseCase = MockLocalStorageUseCase();
    employeesBloc = EmployeesBloc(
      employeeUseCase: mockEmployeeUseCase,
      localStorageUseCase: mockLocalStorageUseCase,
    );
  });

  group('EmployeesBloc |', () {
    test('initial: should have the correct initial state', () {
      expect(employeesBloc.state, EmployeesState.initial());
    });

    blocTest<EmployeesBloc, EmployeesState>(
      'success: should emit EmployeesState with success state and employee data when EmployeeUseCase.getEmployees is called and succeeds',
      // Arrange
      build: () {
        when(mockEmployeeUseCase.getEmployees())
            .thenAnswer((_) async => Result.success(employeesFake));
        return employeesBloc;
      },
      // Act
      act: (bloc) => bloc.getEmployees(),
      // Assert
      expect: () => [
        employeesBloc.state.loading(),
        employeesBloc.state.success(employeesFake),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'failure: should emit EmployeesState with failure state and cached employees when EmployeeUseCase.getEmployees fails',
      // Arrange
      build: () {
        when(mockEmployeeUseCase.getEmployees()).thenAnswer(
            (_) async => Result.failure(const Failure('Failed to fetch employees'), employeesFake));
        return employeesBloc;
      },
      // Act
      act: (bloc) => bloc.getEmployees(),
      // Assert
      expect: () => [
        employeesBloc.state.loading(),
        employeesBloc.state.failure(message: 'Failed to fetch employees', employees: employeesFake),
      ],
    );
  });

  // Additional test for the getUserName method
  group('EmployeesBloc.getUserName |', () {
    test('should return the user name from the LocalStorageUseCase', () {
      // Arrange
      when(mockLocalStorageUseCase.getUser()).thenReturn(UserEntity(id: 1, name: 'John Doe'));

      // Act
      final userName = employeesBloc.getUserName();

      // Assert
      expect(userName, 'John Doe');
      verify(mockLocalStorageUseCase.getUser()).called(1);
      verifyNoMoreInteractions(mockLocalStorageUseCase);
    });

    test('should return an empty string when there is no user in LocalStorageUseCase', () {
      // Arrange
      when(mockLocalStorageUseCase.getUser()).thenReturn(null);

      // Act
      final userName = employeesBloc.getUserName();

      // Assert
      expect(userName, '');
      verify(mockLocalStorageUseCase.getUser()).called(1);
      verifyNoMoreInteractions(mockLocalStorageUseCase);
    });
  });
}
