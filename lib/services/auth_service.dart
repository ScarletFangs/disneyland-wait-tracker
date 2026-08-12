import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get user => _firebaseAuth.authStateChanges();
  String? get currentUserId => _firebaseAuth.currentUser?.uid;
  bool? get isCurrentUserAnonymous => _firebaseAuth.currentUser?.isAnonymous;
  String? get currentUserEmail => _firebaseAuth.currentUser?.email;

  Future<String?> createAccount(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint("$e");
      return _translatedAuthMessage(e.code);
    } catch (e) {
      debugPrint("$e");
      return "Something went wrong... Please try again later.";
    }
  }

  Future<String?> userLogin(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint("$e");
      return _translatedAuthMessage(e.code);
    } catch (e) {
      debugPrint("$e");
      return "Something went wrong... Please try again later.";
    }
  }

  Future<String?> guestLogin() async {
    try {
      await _firebaseAuth.signInAnonymously();
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint("$e");
      return _translatedAuthMessage(e.code);
    } catch (e) {
      debugPrint("Failed to login as guest: $e");
      return "Something went wrong... Please try again later.";
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> linkGuestToAccount(String email, String password) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return "Something went wrong... Please try again later.";
    }
    try {
      await user.linkWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint("$e");
      return _translatedAuthMessage(e.code);
    } catch (e) {
      debugPrint("$e");
      return "Something went wrong... Please try again later.";
    }
  }

  String _translatedAuthMessage(String code) {
    switch (code) {
      case "email-already-in-use":
        return "Email already in use";
      case "invalid-email":
        return "Invalid Email: Please enter a valid email address.";
      case "weak-password":
        return "Password needs to be 6 characters long.";
      case "network-request-failed":
        return "Network request failed: Please check your internet connection.";
      case "invalid-credential":
        return "Email or password incorrect.";
      default:
        return "Error occurred: Please try again later.";
    }
  }
}
