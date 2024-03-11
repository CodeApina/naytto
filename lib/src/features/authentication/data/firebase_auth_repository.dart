import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/app_user.dart';
part 'firebase_auth_repository.g.dart';

// Manages authentication-related operations using Firebase services.
class AuthRepository {
  // Firebase authentication instance.
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  // Stream for observing authentication state changes.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Get the current authenticated user.
  User? get currentUser => _auth.currentUser;

  Future<void> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'signed in';
    } on FirebaseAuthException catch (e) {
      String authError = "";
      if (e.message!.contains('password is invalid')) {
        authError = 'Password is invalid';
      } else if (e.message!.contains('email is invalid')) {
        authError = 'User not found, please check your email-adress';
      } else if (e.code == 'user-not-found') {
        authError = 'User not found, please check your email-adress';
      } else if (e.message!.contains('due to unusual activity')) {
        authError =
            'Access to this account has been temporarily disabled due to many failed login attempts. Please try again later.';
      } else {
        authError = "Unknown error has accured";
      }
      return authError;
    }
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}

// Riverpod provider for the FirebaseAuth instance.
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

// Riverpod provider for the AuthRepository instance.
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
}

// Riverpod provider for observing authentication state changes.
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
