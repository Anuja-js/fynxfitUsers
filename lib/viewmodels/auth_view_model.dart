import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authentication ViewModel Provider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, User?>((ref) {
  return AuthViewModel();
});

/// Authentication ViewModel
class AuthViewModel extends StateNotifier<User?> {
  AuthViewModel() : super(FirebaseAuth.instance.currentUser) {
    _authStateListener();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _authStateListener() {
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }

  /// Sign In with Email & Password
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = userCredential.user;
      return null; // Success, return null error
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    }
  }

  /// Google Sign-In
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "Google Sign-In was canceled";

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      state = userCredential.user;
      return null;
    } catch (e) {
      return "Google Sign-In Failed: $e";
    }
  }

  /// Forgot Password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } catch (e) {
      return "Failed to send reset email: $e";
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    state = null;
  }
}
