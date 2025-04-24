import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
final isLoadingProvider = StateProvider<bool>((ref) => false);

final authProvider = StateNotifierProvider<AuthViewModel, User?>((ref) {
  return AuthViewModel();
});

class AuthViewModel extends StateNotifier<User?> {
  AuthViewModel() : super(FirebaseAuth.instance.currentUser) {
    _authStateListener();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _authStateListener() {
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }

  /// **Sign Up with Email & Password**
  Future<String?> signUpWithEmail(String email, String password) async {
    try {
      print("Attempting sign up...");
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      print("User created: ${user?.uid}");

      if (user != null) {
        await _saveUserToFirestore(user);
      }

      state = user;
      return null; // Success
    } catch (e) {
      print("Sign up error: $e");
      state = _auth.currentUser;
      return e.toString();
    }
  }
  Future<bool> checkUserProfile(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return userDoc.data()?['completeProfileOnboarding'] ?? false;
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
    return false; // Default to false if an error occurs
  }
  Future<void> resetUserData(String userId) async {
    await _firestore.collection('users').doc(userId).set({
      'gender': null,
      'birthday': null,
      'weight': null,
      'height': null,
      'fitnessGoals': null,
      'profileImage': null,
      "name":null,
      "displayName":null,
      "subscribe":false,
      'completeProfileOnboarding': false,
    }, SetOptions(merge: true));
  }
  /// **Sign In with Email & Password**
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      print("Attempting sign in...");
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      print("User signed in: ${user?.uid}");

      if (user != null) {
        await _updateUserLoginTime(user);
      }

      state = user;
      return user; // ✅ Return User? instead of String?
    } on FirebaseAuthException catch (e) {
      print("Sign in error: $e");
      state = _auth.currentUser;
      return null; // ✅ Return null if login fails
    }
  }

  /// **Google Sign-In**
  Future<User?> signInWithGoogle() async {
    try {
      print("Attempting Google Sign-In...");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User canceled login

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        print("Google User Signed In: ${user.uid}");
        await _saveUserToFirestore(user);
      }

      return user; // ✅ Return User? instead of String?
    } catch (e, stackTrace) {
      print("Google Sign-In error: $e");
      print(stackTrace);
      return null; // ✅ Return null if login fails
    }
  }


  /// **Forgot Password**
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to $email");
      return null; // Success
    } catch (e) {
      print("Failed to send reset email: $e");
      return "Failed to send reset email: $e";
    }
  }

  //Sign Out (Logout)
  Future<void> signOut() async {
    print("Signing out...");
    await GoogleSignIn().signOut();
    await _auth.signOut();
    state = null;
  }

  // Save New User Data to Firestore
  Future<void> _saveUserToFirestore(User user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),

"completeProfileOnboarding":false        });
        print("User data saved to Firestore: ${user.uid}");
      }
    } catch (e) {
      print("Error saving user to Firestore: $e");
    }
  }

  /// **Update Last Login Time**
  Future<void> _updateUserLoginTime(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
      print("User last login updated: ${user.uid}");
    } catch (e) {
      print("Error updating login time: $e");
    }
  }
}
