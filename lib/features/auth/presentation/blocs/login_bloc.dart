import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/domain/use_cases/local_storage_use_case.dart';
import '../../domain/entities/login_credentials_entity.dart';
import '../../domain/use_cases/auth_use_case.dart';
import 'login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  final AuthUseCase _authUseCase;
  final LocalStorageUseCase _localStorage;
  LoginBloc({
    required AuthUseCase authUseCase,
    required LocalStorageUseCase localStorage,
  })  : _authUseCase = authUseCase,
        _localStorage = localStorage,
        super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    final credentials = LoginCredentialsEntity(username: username, password: password);
    final result = await _authUseCase.login(credentials);
    result.when(
      onSuccess: (user) {
        _localStorage.saveUser(user);
        emit(LoginSuccess(user: user));
      },
      onFailure: (failure, _) {
        emit(LoginError(message: failure.message));
      },
    );
  }
}
