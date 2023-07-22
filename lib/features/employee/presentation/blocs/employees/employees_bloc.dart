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
        super(EmployeesState.initial());

  Future<void> getEmployees() async {
    emit(state.loading());
    final result = await _employeeUseCase.getEmployees();
    result.when(
      onSuccess: (data) {
        emit(state.success(data));
      },
      onFailure: (failure, cachedEmployees) {
        emit(state.failure(
          employees: cachedEmployees,
          message: failure.message,
        ));
      },
    );
  }

  String getUserName() => _localStorageUseCase.getUser()?.name ?? '';
}
