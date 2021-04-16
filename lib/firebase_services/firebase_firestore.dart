import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  FirebaseFirestore _firestore;
  StoreService(this._firestore);

  FirebaseFirestore getInstance() => _firestore;

  // /post
  CollectionReference getPostsRef() =>  _firestore.collection("post");

  DocumentReference getPostRef(String id) => getPostsRef().doc(id);
  

  // /post/comments
  DocumentReference getCommentRef(String postId, String commentId) => getCommentsRef(postId).doc(commentId);

  CollectionReference getCommentsRef(String postId) => getPostRef(postId).collection("comments");

  CollectionReference getLikesRef(String postId) => getPostRef(postId).collection("likes");

  DocumentReference getLikeRef(postId, likeId) => getLikesRef(postId).doc(likeId);

  // /user
  CollectionReference getUsersRef() => _firestore.collection("user");
  DocumentReference getUserRef(uid) => getUsersRef().doc(uid);
}
