import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/domain/use_cases/local_storage_use_case.dart';
import '../../../domain/use_cases/employee_use_case.dart';
import 'employees_state.dart';

class EmployeesBloc extends Cubit<EmployeesState> {
  final EmployeeUseCase _employeeUseCase;
  final LocalStorageUseCase _localStorageUseCase;

  EmployeesBloc({
    required EmployeeUseCase employeeUseCase,
    required LocalStorageUseCase localStorageUseCase,
  })  : _employeeUseCase = employeeUseCase,
        _localStorageUseCase = localStorageUseCase,
        super(EmployeesInitial());

  Future<void> getEmployees() async {
    emit(EmployeesLoading());
    final result = await _employeeUseCase.getEmployees();
    result.when(
      onSuccess: (data) {
        emit(EmployeesSuccess(employees: data));
      },
      onFailure: (failure, cachedEmployees) {
        emit(EmployeesError(message: failure.message));
      },
    );
  }

  String getUserName() => _localStorageUseCase.getUser()?.name ?? '';
}
