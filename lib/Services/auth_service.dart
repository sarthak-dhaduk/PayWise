import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywise/main.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:paywise/screens/SetPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'authentication';

  // Create user with email and password
  Future<Map<String, String>?> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      String authId = _firestore.collection(collectionName).doc().id;

      await _firestore.collection(collectionName).doc(authId).set({
        'auth_id': authId,
        'email': email,
        'password': password,
        'name': name,
        'user_type': 'basic user',
      });

      // Return user data as a map
      return {'email': email, 'auth_id': authId};
    } catch (e) {
      log("Error creating user: $e");
      return null; // Return null in case of error
    }
  }

  Future<Map<String, String>?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      // Fetch the document from Firestore by email
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve user data
        final userData = querySnapshot.docs.first.data();

        // Check if the entered password matches the stored password
        if (userData['password'] == password) {
          if (userData['user_type'] == null) {
            await querySnapshot.docs.first.reference
                .update({'user_type': 'basic user'});
          }
          // Return email and auth_id on success
          return {'email': userData['email'], 'auth_id': userData['auth_id']};
        } else {
          // Return null if password is incorrect
          return null;
        }
      } else {
        // Return null if no user found with this email
        return null;
      }
    } catch (error) {
      log("Error during login: $error");
      return null; // Return null in case of error
    }
  }

  Future<void> updateUserTypeToPremium(String authId) async {
    try {
      await _firestore.collection(collectionName).doc(authId).update({
        'user_type': 'premium user',
      });
      log("User type updated to premium user.");
    } catch (error) {
      log("Error updating user type: $error");
    }
  }

  // Google Sign-in
  Future<Map<String, String>?> signInWithGoogle() async {
    try {
      // Perform the Google sign-in
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null; // User aborted sign-in
      }

      // Retrieve Google Sign-In authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Ensure that accessToken and idToken are not null
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Google sign-in authentication failed. Missing token.');
      }

      // Sign in to Firebase with the Google credentials
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase and retrieve user details
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Ensure user is not null before proceeding
      if (user == null) {
        throw Exception('Google sign-in failed. No user information.');
      }

      final uid = user.uid;
      final email = user.email ?? 'No email';
      final displayName = user.displayName ?? 'No name';

      // Fetch user data from Firestore by email
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('authentication')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final password = userDoc['password'];

        if (userDoc['user_type'] == null) {
          await userDoc.reference.update({'user_type': 'basic user'});
        }

        // If the password is not null, sign in and go to Home screen
        if (password != null && password.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final BuildContext? currentContext =
                navigatorKey.currentState?.context;

            if (currentContext != null) {
              Navigator.of(currentContext).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          });
        } else {
          // If the password is null, prompt user to recover password
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final BuildContext? currentContext =
                navigatorKey.currentState?.context;

            if (currentContext != null) {
              Navigator.of(currentContext).pushReplacement(
                MaterialPageRoute(builder: (context) => SetPassword(uid: uid)),
              );
            }
          });
        }
      } else {
        // If user doesn't exist in Firestore, create a new entry
        await firestore.collection('authentication').doc(uid).set({
          'auth_id': uid,
          'email': email,
          'name': displayName,
          'password': null, // Password initially set to null
          'user_type': 'basic user',
        });

        // Redirect to SetPassword screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final BuildContext? currentContext =
              navigatorKey.currentState?.context;

          if (currentContext != null) {
            Navigator.of(currentContext).pushReplacement(
              MaterialPageRoute(builder: (context) => SetPassword(uid: uid)),
            );
          }
        });
      }

      // Return user details as a map
      return {
        'uid': uid,
        'email': email,
      };
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signout() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('auth_id');

      log("Signed out successfully.");
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  // Get current user details
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? authId = prefs.getString('auth_id');

    if (email != null && authId != null) {
      return {
        'email': email,
        'auth_id': authId,
      };
    }
    return null;
  }
}