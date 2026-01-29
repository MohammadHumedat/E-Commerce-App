import 'package:e_commerce_app/Constants/api_paths.dart';
import 'package:e_commerce_app/models/user_model.dart';
import 'package:e_commerce_app/services/auth_service.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    FirebaseAuth.instance.authStateChanges().listen((user) { // Listen to auth state changes
      if (user != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  final AuthService _authService = AuthServiceImpl();
  final firestoreService = FirestoreService.instance;

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
    String userName,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authService.registerWithEmailAndPassword(
        email,
        password,
      );
      if (result) {
        final currentUser = _authService.currentUser;
        final userData = UserData(
          uid: currentUser!.uid,
          email: email,
          userName: userName,
          createdAt: DateTime.now().toIso8601String(),
        );
        firestoreService.setData(
          path: ApiPaths.users(userData.uid),
          data: userData.toMap(),
        );
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
      emit(
        GoogleAuthenticationFailed(
          'Google authentication failed: ${e.toString()}',
        ),
      );
    }
  }
}
