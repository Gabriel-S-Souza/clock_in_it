import 'package:equatable/equatable.dart';

import '../../../domain/entities/employee_entity.dart';

class EmployeesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoading extends EmployeesState {}

class EmployeesSuccess extends EmployeesState {
  final List<EmployeeEntity> employees;

  EmployeesSuccess({required this.employees});
}

class EmployeesError extends EmployeesState {
  final String message;

  EmployeesError({required this.message});
}
