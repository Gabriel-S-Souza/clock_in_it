import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/user/user_entity.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;

  LoginSuccess({required this.user});
}

class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}
