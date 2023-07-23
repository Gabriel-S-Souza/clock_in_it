import 'package:bloc_test/bloc_test.dart';
import 'package:clock_in_it/features/employee/domain/entities/employee_details_entity.dart';
import 'package:clock_in_it/features/employee/presentation/blocs/employee_details/employee_details_bloc.dart';
import 'package:clock_in_it/features/employee/presentation/blocs/employee_details/employee_details_state.dart';
import 'package:clock_in_it/shared/domain/entities/failure/failure.dart';
import 'package:clock_in_it/shared/domain/entities/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes/employee_details_fake.dart';
import '../../../mocks/build_mocks.mocks.dart';

void main() {
  late EmployeeDetailsBloc employeeDetailsBloc;
  late MockEmployeeUseCase mockEmployeeUseCase;

  setUp(() {
    mockEmployeeUseCase = MockEmployeeUseCase();
    employeeDetailsBloc = EmployeeDetailsBloc(mockEmployeeUseCase);
  });

  group('EmployeeDetailsBloc |', () {
    test('initial: should have the correct initial state', () {
      expect(employeeDetailsBloc.state, EmployeeDetailsInitial());
    });

    blocTest<EmployeeDetailsBloc, EmployeeDetailsState>(
      'success: should emit an EmployeeDetailsLoagding and then an EmployeeDetailsSuccess when EmployeeUseCase.getDetails is called and succeeds',
      // Arrange
      build: () {
        const employeeId = '1';
        when(mockEmployeeUseCase.getDetails(employeeId)).thenAnswer(
          (_) async => Result.success(employeeDetailsFake),
        );
        return employeeDetailsBloc;
      },
      // Act
      act: (bloc) => bloc.getDetails('1'),
      // Assert
      expect: () => [
        isA<EmployeeDetailsLoading>(),
        isA<EmployeeDetailsSuccess>().having(
          (state) => state.details,
          'details',
          isA<EmployeeDetailsEntity>(),
        ),
      ],
    );

    blocTest<EmployeeDetailsBloc, EmployeeDetailsState>(
      'failure: should emit EmployeeDetailsLoading and then EmployeeDetailsError with the failure message when EmployeeUseCase.getDetails fails',
      // Arrange
      build: () {
        const employeeId = '1';
        when(mockEmployeeUseCase.getDetails(employeeId)).thenAnswer(
          (_) async => Result.failure(const Failure('Failed to fetch employee details')),
        );
        return employeeDetailsBloc;
      },
      // Act
      act: (bloc) => bloc.getDetails('1'),
      // Assert
      expect: () => [
        isA<EmployeeDetailsLoading>(),
        isA<EmployeeDetailsError>().having(
          (state) => state.message,
          'message',
          isA<String>(),
        ),
      ],
    );
  });
}
