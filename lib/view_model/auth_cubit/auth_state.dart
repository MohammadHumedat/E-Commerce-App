part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  AuthAuthenticated();
}

final class AuthUnauthenticated extends AuthState {}

final class AuthError extends AuthState {
  AuthError(this.message);
  final String message;
}

final class GoogleAuthenticating extends AuthState {}
final class GoogleAuthenticated extends AuthState {}
final class GoogleAuthenticationFailed extends AuthState {
  GoogleAuthenticationFailed(this.message);
  final String message;
}
