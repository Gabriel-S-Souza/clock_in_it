import 'package:equatable/equatable.dart';

import '../../../domain/entities/employee_entity.dart';

class EmployeesState extends Equatable {
  final List<EmployeeEntity> employees;
  final bool isLoading;
  final String? messageError;

  const EmployeesState({
    this.employees = const [],
    this.isLoading = false,
    this.messageError,
  });

  bool get hasError => messageError != null;

  EmployeesState copyWith({
    List<EmployeeEntity>? employees,
    bool? isLoading,
    String? messageError,
  }) =>
      EmployeesState(
        employees: employees ?? this.employees,
        isLoading: isLoading ?? this.isLoading,
        messageError: messageError ?? this.messageError,
      );

  static EmployeesState initial() => const EmployeesState();

  EmployeesState loading() => copyWith(isLoading: true);

  EmployeesState success(List<EmployeeEntity> employees) => copyWith(
        employees: employees,
        isLoading: false,
      );

  EmployeesState failure({
    required String message,
    List<EmployeeEntity>? employees,
  }) =>
      copyWith(
        employees: employees,
        messageError: message,
        isLoading: false,
      );

  @override
  List<Object?> get props => [employees, isLoading, messageError];
}
