import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  AuthProvider() {
    _auth.authStateChanges().listen((firebaseUser) {
      user = firebaseUser;
      notifyListeners();
    });
  }

  bool get isAuthenticated => user != null;

  Future<void> logout() async {
    await _auth.signOut();
  }
}
