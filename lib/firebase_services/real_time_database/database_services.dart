import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase _firebaseDatabase;
  DatabaseReference _postsRef;
  DatabaseReference _userRef;

  DatabaseService(this._firebaseDatabase) {
    _firebaseDatabase.setPersistenceEnabled(false);
  }

  FirebaseDatabase getInstance() => _firebaseDatabase;
  DatabaseReference getPostsRef() {
    if (_postsRef == null) {
      _postsRef = _firebaseDatabase.reference().child('post/');
    }
    return _postsRef;
  }

  DatabaseReference getPostsListRef() =>
      _firebaseDatabase.reference().child('postList/');
  Future<Map<String, dynamic>> getPost(String id) async {
    var dbPostData = (await getPostsRef().child(id).once()).value;
    if (dbPostData == null) {
      print("post doesnt exist");
      return null;
    }

    return {
      "images": dbPostData['images'],
      "description": dbPostData['description'],
      "owner": dbPostData['owner'],
      "private": dbPostData['private'],
      "id": id,
      "time": dbPostData['time'],
      "aspects": dbPostData['aspects']
    };
  }

  DatabaseReference getUserRef(uid) {
    return _firebaseDatabase.reference().child('users/$uid');
  }

  DatabaseReference getUserPostsRef(uid) => getUserRef(uid).child("posts");

  void deletePost(String id) {}
}
