part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFAilure extends AuthState {
  final String errorMessage;

  LoginFAilure({
    required this.errorMessage,
  });
}

