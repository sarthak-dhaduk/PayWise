import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user with email and password
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  // Login user with email and password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Save email and uid to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('uid', cred.user!.uid);

      return cred.user;
    } catch (e) {
      log("Error logging in user: $e");
    }
    return null;
  }

  // Google Sign-in
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Save user details to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', userCredential.user!.email!);
      await prefs.setString('uid', userCredential.user!.uid);

      return userCredential.user;
    } catch (e) {
      log("Error signing in with Google: $e");
    }
    return null;
  }

  // Sign out
  Future<void> signout() async {
    try {
      await _auth.signOut();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
