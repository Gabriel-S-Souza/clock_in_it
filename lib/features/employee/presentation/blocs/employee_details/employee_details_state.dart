import 'package:equatable/equatable.dart';

import '../../../domain/entities/employee_details_entity.dart';

class EmployeeDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeeDetailsInitial extends EmployeeDetailsState {}

class EmployeeDetailsLoading extends EmployeeDetailsState {}

class EmployeeDetailsSuccess extends EmployeeDetailsState {
  final EmployeeDetailsEntity details;

  EmployeeDetailsSuccess(this.details);
}

class EmployeeDetailsError extends EmployeeDetailsState {
  final String message;

  EmployeeDetailsError(this.message);
}
