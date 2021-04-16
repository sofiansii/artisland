import 'dart:async';

import 'package:artisland/domain/entities/user.dart';
import 'package:artisland/firebase_services/auth/authentication_service.dart';

import 'package:artisland/firebase_services/firebase_firestore.dart';
import 'package:artisland/firebase_services/storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManager {
  static StoreService _storeService = StoreService(FirebaseFirestore.instance);
  static User _user;

  static _onListen() {
    AuthenticationService.userChanges.listen((event) async {
      if (event != null)
        user = await getUser(event.uid);
      else
        user = null;
    });
  }

  static StreamController<User> _userStream = StreamController<User>.broadcast(
    onListen: _onListen(),
  );
  //static _onCancel() => _userStream.close();

  static void _printError(error, stackTrace) {
    print("error: $error");
    print(stackTrace);
    return null;
  }

  static destroy() {
    _userStream.close();
  }

  static set user(User user) {
    _user = user;
    _userStream.add(user);
  }

  static User get user => _user;
  static Stream<User> get userStream => _userStream.stream;

  static Future<String> createUserProfile(
    String email,
    String password,
    String fullName,
    String sex,
  ) async {
    DocumentReference dbUser;
    try {
      var res = await AuthenticationService.signUp(email: email, password: password, displayName: fullName);

      dbUser = _storeService.getUserRef(res);
      var data = {
        "fullName": fullName,
        "profileImage": sex == "male" ? await StorageService.getDefaultMan() : await StorageService.getDefaultWoman(),
        "backgroundImage": await StorageService.getDefaultBackground(),
        "sex": sex,
        "description": "art lover",
        "email": email,
      };
      await dbUser.set(data);
      return null;
    } catch (e, s) {
      _printError(e, s);

      if (dbUser != null) dbUser.delete();
      return (e as FirebaseException).message;
    }
  }

  static Future<User> getUser(String uid) async {
    try {
      var dbUser = await _storeService.getUserRef(uid).get();
      var user = User(
        fullName: dbUser.get("fullName"),
        email: dbUser.get("email"),
        backgroundImage: dbUser.get("backgroundImage"),
        description: dbUser.get("description"),
        profileImage: dbUser.get("profileImage"),
        sex: dbUser.get("sex"),
      );
      return user;
    } catch (e, s) {
      _printError(e, s);
      return null;
    }
  }
}
