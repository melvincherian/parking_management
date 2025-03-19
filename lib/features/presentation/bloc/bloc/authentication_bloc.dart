// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:parking_management/firebase/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;

  AuthenticationBloc({required AuthRepository authrepository})
      : _authRepository = authrepository,
        super(AuthenticationInitial()) {
    on<SignupRequested>(_onsignupRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onsignupRequested(
    SignupRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final result = await _authRepository.signupUser(
        name: event.name, email: event.email, password: event.password);

    if (result == 'Success') {
      emit(AuthenticationSuccess(
          userId: _authRepository.currentuser!.uid, source: 'signup'));
    } else {
      emit(AuthenticationFailure(error: result, source: 'signup'));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final result = await _authRepository.loginUser(
        email: event.email, password: event.password);
    if (result == 'Success') {
      emit(AuthenticationSuccess(
          userId: _authRepository.currentuser!.uid, source: 'login'));
    } else {
      emit(AuthenticationFailure(error: result, source: 'login'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authRepository.logout();
    emit(AuthenticationLoggedOut());
  }
}
