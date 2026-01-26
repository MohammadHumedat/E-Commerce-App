import 'package:e_commerce_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated());
      } else {
        if (state is! AuthLoading) {
          emit(AuthUnauthenticated());
        }
      }
    });
  }
  final AuthService _authService = AuthServiceImpl();

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());
    try {
      final result = await _authService.loginWithEmailAndPassword(
        email,
        password,
      );
      if (result) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authService.registerWithEmailAndPassword(
        email,
        password,
      );
      if (result) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  void checkAuthentication() {
    final user = _authService.currentUser;
    if (user != null) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> authenticateWithGoogle() async {
    emit(GoogleAuthenticating());
    try {
      final result = await _authService.authenticateWithGoogle();
      if (result) {
        emit(GoogleAuthenticated());
        emit(AuthAuthenticated());
      } else {
        emit(GoogleAuthenticationFailed('Google authentication failed'));
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(GoogleAuthenticationFailed('Google authentication failed: ${e.toString()}'));
    }
  }
}
