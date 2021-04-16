import 'dart:async';

import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/pages/profile/newPost/new_post.dart';
import 'package:artisland/pages/profile/slider/my_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:artisland/pages/common/Colors.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  PostData postData;
  Post(this.postData);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final icon_splash_radius = 20.1;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.memory(
          widget.postData.u8intImages[0],
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width - 20,
        ),
        color: Colors.red);
  }

  void editPost() async {
    var time = (Timestamp.now().millisecondsSinceEpoch - widget.postData.time.microsecondsSinceEpoch) / (1000 * 3600);
    PostData newPost;
    if (time < 24) {
      newPost = await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
        return NewPostPage(widget.postData, edit: Edit.early);
      }));
      if (newPost == null) return;

      newPost.owner = UserManager.user.uid;
      var progressController = new StreamController<double>.broadcast(onCancel: ScaffoldMessenger.of(context).hideCurrentSnackBar);
      PostManager.editPost(newPost, progressController).then((value) {
        if (!value) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong...")));
          return;
        } else {
          setState(() {
            widget.postData = newPost;
          });
        }
      });

      var pBar = new MyProgressBar(progressController.stream);
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: pBar,
        duration: Duration(days: 20),
        behavior: SnackBarBehavior.fixed,
      ));
    } else {
      print("edit");
      newPost = await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
        return NewPostPage(widget.postData, edit: Edit.late);
      }));
      if (newPost == null) return;

      PostManager.lateEditPost(newPost).then((value) {
        if (value) {
          setState(() => widget.postData = newPost);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong...")));
        }
      });
    }
  }
}
