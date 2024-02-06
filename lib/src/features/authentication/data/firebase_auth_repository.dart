import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password).then((data) {
      AppUser().createUser(data);
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
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
