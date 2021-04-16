import 'dart:typed_data';

import 'package:artisland/domain/image/image_manager.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class StorageService {
  static final FirebaseStorage _storageService = FirebaseStorage.instance;
  FirebaseStorage getInstance() => _storageService;

  static void printError(error, stackTrace) {
    print("error: $error");
    print(stackTrace);
    return null;
  }

  static Reference getUserPosts(String uid) => getUserFolder("$uid/postImages/");

  static Reference getUserFolder(String uid) => _storageService.ref("$uid");

  static Future<void> putPostImage(Uint8List uint8Image, String fileName, String uid) async {
    await getUserPosts(uid).child(fileName).putData(uint8Image);
  }

  static Future<void> deletePostImage(String fileName, String uid) async {
    await getUserPosts(uid).child(fileName).delete();
  }

  static Future<Uint8List> getPostImage(String uid, String fileName) async {
    try {
      var data = await getUserPosts(uid).child(fileName).getData();
      print("image size${data.length}");
      print("dems are: ${await ImageManager.getDementionsFromAsset(data)}");
      return data;
    } catch (e, s) {
      printError(e, s);
      return null;
    }
  }

  static Future<Uint8List> getImage(String ref) async {
    try {
      return await _storageService.ref(ref).getData();
    } catch (e, s) {
      printError(e, s);
      return null;
    }
  }

  static Future<String> getDefaultMan() async {
    try {
      return await _storageService.ref("defaults/man.png").getDownloadURL();
    } catch (e, s) {
      printError(e, s);
      return "";
    }
  }

  static Future<String> getDefaultWoman() async {
    try {
      return await _storageService.ref("defaults/woman.png").getDownloadURL();
    } catch (e, s) {
      printError(e, s);
      return "";
    }
  }

  static Future<String> getDefaultBackground() async {
    try {
      return await _storageService.ref("defaults/background.jpg").getDownloadURL();
    } catch (e, s) {
      printError(e, s);
      return "";
    }
  }
}
