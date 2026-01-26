import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<bool> loginWithEmailAndPassword(String email, String password);
  Future<bool> registerWithEmailAndPassword(String email, String password);
  User? get currentUser => FirebaseAuth.instance.currentUser;
  Future<bool> authenticateWithGoogle();
  Future<void> logout();
}

class AuthServiceImpl implements AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<bool> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<void> logout() async {
    GoogleSignIn.instance.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> authenticateWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(); // Ensure initialization
      await GoogleSignIn.instance.signOut(); // Sign out any existing sessions
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate(); // Trigger the authentication flow

      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        // Create a new credential
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return false;
    }
  }
}
