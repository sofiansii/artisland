import 'dart:async';

import 'package:artisland/domain/user/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:artisland/domain/entities/user.dart' as local;

enum UserAuthState {
  loggedIn,
  loggedOut,
}

class AuthenticationService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Stream<User> get userChanges => _firebaseAuth.authStateChanges();

  static void printError(error, stackTrace) {
    print("\n");
    print("error: $error");
    print(stackTrace);
    print("\n");
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  static Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      print("error :" + e.message);
      return e.message;
    }
  }

  static Future<String> signUp({@required String email, @required String password, @required String displayName}) async {
    var user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.user.uid;
  }
}
