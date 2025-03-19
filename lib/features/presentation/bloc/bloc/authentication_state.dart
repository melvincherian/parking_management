part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState{}

class AuthenticationSuccess extends AuthenticationState{
  final String userId;
  final String source;

  AuthenticationSuccess({required this.userId,required this.source});

}

class AuthenticationFailure extends AuthenticationState{
  final String error;
  final String source;

  AuthenticationFailure({required this.error,required this.source});
  
}


final class AuthenticationLoggedOut extends AuthenticationState {}