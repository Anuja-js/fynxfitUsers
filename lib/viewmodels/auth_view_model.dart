import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../views/signup/otp_verification_screen.dart';

/// Authentication ViewModel Provider
final authProvider = StateNotifierProvider<AuthViewModel, User?>((ref) {
  return AuthViewModel();
});

/// Authentication ViewModel
class AuthViewModel extends StateNotifier<User?> {
  AuthViewModel() : super(FirebaseAuth.instance.currentUser) {
    _authStateListener();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Listen to authentication state changes

  void _authStateListener() {
    _auth.authStateChanges().listen((user) {
      state = user ?? null; // Ensure UI updates on logout
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
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An unknown error occurred"; // Return error message
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
      return null; // Success
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



  Future<bool> sendOtp(String phoneNumber, BuildContext context) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          state = _auth.currentUser;
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Error")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyOtp(String verificationId, String otp, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      state = _auth.currentUser;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified!")),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
      return false;
    }
  }
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    state = null;
  }
}
