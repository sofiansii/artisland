import 'dart:async';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:artisland/domain/entities/comment.dart';
import 'package:artisland/domain/entities/llike.dart';
import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/image/image_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/firebase_services/firebase_firestore.dart';
import 'package:artisland/firebase_services/storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostManager {
  static StoreService _storeService = StoreService(FirebaseFirestore.instance);
  static List<String> userPosts;
  static List<String> publicPosts;

  static List<String> _hashImages(List<Uint8List> images) {
    List<String> hashes = [];
    for (var image in images) {
      var hashstr = "${image.length}:${image.lengthInBytes}";
      var bytes = utf8.encode(hashstr);
      bytes = bytes += image.getRange(1000, 1004).toList();
      hashes.add("${md5.convert(bytes).toString()}:${Timestamp.now().millisecondsSinceEpoch}");
    }
    return hashes;
  }

  static FutureOr<dynamic> handleStoreError(error, stackTrace) {
    print("error: $error");
    print(stackTrace);
    return null;
  }

  static void printError(error, stackTrace) {
    print("error: $error");
    print(stackTrace);
    return null;
  }

  static Future<bool> addStorePost(PostData newPost, StreamController<double> streamController) async {
    try {
      var doc = _storeService.getPostsRef().doc();
      var aspects = [];
      var dems = await Future.wait([for (var i = 0; i < newPost.u8intImages.length; i++) ImageManager.getDementionsFromAsset(newPost.u8intImages[i])]);
      for (var d in dems) aspects.add((d[1] / d[0]).toDouble());
      var imageHashes = _hashImages(newPost.u8intImages);
      newPost.time = Timestamp.now();
      var data = {
        'uid': newPost.owner,
        'description': newPost.description,
        'images': imageHashes,
        "private": newPost.private,
        "time": newPost.time,
        "aspects": aspects,
        "ispinned": newPost.isPinned
      };

      for (var i = 0; i < newPost.u8intImages.length; i++) {
        await StorageService.putPostImage(newPost.u8intImages[i], imageHashes[i], newPost.owner);
        print("done: $i");
        streamController.add((i + 1) / newPost.u8intImages.length);
      }
      streamController.close();
      doc.set(data);
      return true;
    } catch (e, s) {
      printError(e, s);
      streamController.close();
      return false;
    }
  }

  static Future<bool> editPost(PostData postData, StreamController<double> streamController) async {
    try {
      var dbPost = _storeService.getPostRef(postData.id);
      var doc = await dbPost.get();

      var aspects = [];
      var dems = await Future.wait([for (var i = 0; i < postData.u8intImages.length; i++) ImageManager.getDementionsFromAsset(postData.u8intImages[i])]);
      for (var d in dems) aspects.add((d[1] / d[0]).toDouble());
      var imageHashes = _hashImages(postData.u8intImages);

      var data = {
        'uid': postData.owner,
        'description': postData.description,
        'images': imageHashes,
        "private": postData.private,
        "time": postData.time,
        "aspects": aspects,
        "ispinned": postData.isPinned
      };

      for (var i = 0; i < postData.u8intImages.length; i++) {
        await StorageService.putPostImage(postData.u8intImages[i], imageHashes[i], postData.owner);
        print("done: $i");
        streamController.add((i + 1) / postData.u8intImages.length);
      }
      dbPost.update(data);
      //delete old images
      List<Future> futures = [];
      for (var image in doc.get("images")) {
        futures.add(StorageService.deletePostImage(image, postData.owner));
      }
      await Future.wait(futures);
      //close stream
      streamController.close();
      return true;
    } catch (e, s) {
      printError(e, s);
      streamController.close();
      return false;
    }
  }

  static Future<bool> lateEditPost(PostData postData) async {
    try {
      var dbPost = _storeService.getPostRef(postData.id);
      var oldImages = (await dbPost.get()).get("images");
      var oldHashes = [for (var i in oldImages) (i as String)];
      var imageHashes = _hashImages(postData.u8intImages);

      for (var oldHash in oldHashes) {
        for (var hash in imageHashes) {
          if (oldHash.split(":")[0] == hash.split(":")[0]) {
            var newpos = imageHashes.indexOf(hash);
            var oldPos = oldHashes.indexOf(oldHash);
            var tmp = oldHashes[oldPos];
            oldHashes[oldPos] = oldHashes[newpos];
            oldHashes[newpos] = tmp;
            continue;
          }
        }
      }

      await dbPost.update({"description": postData.description, "images": oldHashes, "private": postData.private, "ispinned": postData.isPinned});
      return true;
    } catch (e, s) {
      printError(e, s);
      return false;
    }
  }

  static Future<bool> deletePost(String id) async {
    try {
      await _storeService.getPostsRef().doc(id).delete();
      return true;
    } catch (e, s) {
      printError(e, s);
      return false;
    }
  }

  static Future<PostData> getStorePost(QueryDocumentSnapshot doc) async {
    try {
      var postData = PostData();
      List<Future<dynamic>> futures = [];
      for (var i = 0; i < doc.get('images').length; i++) {
        futures.add(StorageService.getPostImage(doc.get('uid'), doc.get('images')[i]));
      }
      futures.add(getPostCmments(doc.id));
      futures.add(getPostLikes(doc.id));
      var res = await Future.wait(futures);
      postData.likes = res.removeLast();
      postData.comments = res.removeLast();

      for (int i = 0; i < res.length; i++) postData.u8intImages.add(res[i]);
      for (var like in postData.likes) if (like.uid == UserManager.user.uid) postData.liked = true;

      postData.description = doc.get('description');
      postData.time = doc.get('time');
      postData.owner = doc.get('uid');
      postData.id = doc.id;
      postData.aspects = [for (var i in doc.get('aspects')) i.runtimeType == int ? i.toDouble() : i];

      return postData;
    } catch (e, s) {
      printError(e, s);
      return null;
    }
  }

  Future<List<PostData>> getSorePublicPosts() async {
    try {
      var pubPosts = await _storeService.getPostsRef().where("private", isEqualTo: false).get().onError((e, s) {
        printError(e, s);
        return null;
      });
      if (pubPosts == null) return [];
      List<Future<PostData>> futures = [];
      for (var doc in pubPosts.docs) {
        futures.add(getStorePost(doc));
      }
      var time = Timestamp.now();
      var res = await Future.wait(futures);
      var newTime = Timestamp.now();
      print("time: ${newTime.millisecondsSinceEpoch - time.millisecondsSinceEpoch}");
      while (res.remove(null)) {
        print("a pub post is null");
      }
      return res;
    } catch (e, s) {
      printError(e, s);
      return [];
    }
  }

  static Future<List<PostData>> getPersonalPosts({String uid}) async {
    try {
      var refs =
          (await _storeService.getPostsRef().where("uid", isEqualTo: uid == null ? UserManager.user.uid : uid).where("private", isNotEqualTo: uid == null ? null : true).get());
      var docs = refs.docs;
      if (docs == null) return [];
      List<Future<PostData>> futures = [];
      for (var doc in docs) {
        futures.add(getStorePost(doc));
      }

      var res = (await Future.wait(futures));
      while (res.remove(null)) {}

      return res;
    } catch (e, s) {
      printError(e, s);
      return [];
    }
  }

  static Future<List<Comment>> getPostCmments(String postId, {Comment newestComment}) async {
    Query getNewComments() {
      return _storeService.getCommentsRef(postId).orderBy('time', descending: true).endBefore([newestComment.time]);
    }

    try {
      var queryResult;
      if (newestComment == null) {
        var postComments = _storeService.getPostRef(postId).collection("comments");
        var dbCommentsQuery = postComments.orderBy("time", descending: true);
        queryResult = await dbCommentsQuery.limit(10).get();
      } else {
        queryResult = await getNewComments().get();
      }
      List<Comment> comments = [];
      for (var doc in queryResult.docs) {
        var c = Comment()
          ..comment = doc.get("comment")
          ..name = doc.get("name")
          ..image = doc.get("image")
          ..uid = doc.get("uid")
          ..time = doc.get("time")
          ..isPinned = doc.get("ispinned")
          ..id = doc.id
          ..postId = postId;
        comments.add(c);
      }
      return comments;
    } catch (e, s) {
      printError(e, s);
      return [];
    }
  }

  static Future<bool> addComment(String postId, String comment, Comment lastComment) async {
    try {
      var newComment = _storeService.getPostRef(postId).collection("comments").doc();
      await newComment.set({
        "uid": UserManager.user.uid,
        "time": Timestamp.now(),
        "comment": comment,
        "image": UserManager.user.profileImage,
        "name": UserManager.user.fullName,
        "ispinned": false,
      });
      return true;
    } catch (e, s) {
      printError(e, s);
      return false;
    }
  }

  static Future<Comment> editComment(Comment comment) async {
    try {
      var dBcomment = _storeService.getCommentRef(comment.postId, comment.id);
      await dBcomment.update({"comment": comment.comment});
      return comment;
    } catch (e, s) {
      printError(e, s);
      return null;
    }
  }

  static Future<Comment> deleteComment(Comment comment) async {
    try {
      await _storeService.getCommentRef(comment.postId, comment.id).delete();
      return comment;
    } catch (e, s) {
      printError(e, s);
      return null;
    }
  }

  static Future<bool> pinComment(String postId, Comment comment) async {
    try {
      var dBcomment = _storeService.getCommentRef(postId, comment.id);
      await dBcomment.update({"ispinned": comment.isPinned});
      return true;
    } catch (e, s) {
      printError(e, s);
      return false;
    }
  }

  static Future<Like> like(postId) async {
    try {
      await _storeService.getLikesRef(postId).doc(UserManager.user.uid).set({"name": UserManager.user.fullName, "image": UserManager.user.profileImage});
      return Like(UserManager.user.uid, UserManager.user.fullName, UserManager.user.profileImage);
    } catch (e, s) {
      printError(e, s);
      return null;
    }
  }

  static Future<Like> unLike(postId) async {
    try {
      await _storeService.getLikeRef(postId, UserManager.user.uid).delete();
      return Like(UserManager.user.uid, UserManager.user.fullName, UserManager.user.profileImage);
    } catch (e, s) {
      printError(e, s);
      return null;
    }
  }

  static Future<List<Like>> getPostLikes(postId) async {
    try {
      var dbLikes = await _storeService.getLikesRef(postId).get();
      var likes = [for (var doc in dbLikes.docs) Like(doc.id, doc.get("name"), doc.get("image"))];
      return likes;
    } catch (e, s) {
      printError(e, s);
      return [];
    }
  }

  void test() async {
    try {
      await _storeService.getPostRef("4ucQx16EhMgKjvZfimmC").collection("comments").doc("test").update({
        "id1": {"uid": "OZYNPPfMxRTBXZ53DoFFC5RLlov2", "text": "see"}
      });
    } catch (e, s) {
      printError(e, s);
      print("error line: 232");
    }
  }
}
