import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/employee_use_case.dart';
import 'employee_details_state.dart';

class EmployeeDetailsBloc extends Cubit<EmployeeDetailsState> {
  final EmployeeUseCase _employeeUseCase;

  EmployeeDetailsBloc(this._employeeUseCase) : super(EmployeeDetailsInitial());

  Future<void> getDetails(String employeeId) async {
    emit(EmployeeDetailsLoading());
    final result = await _employeeUseCase.getDetails(employeeId);

    result.when(onSuccess: (details) {
      emit(EmployeeDetailsSuccess(details));
    }, onFailure: (failure, _) {
      emit(EmployeeDetailsError(failure.message));
    });
  }
}
