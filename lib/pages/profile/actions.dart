import 'dart:async';

import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/pages/profile/newPost/new_post.dart';
import 'package:artisland/pages/profile/slider/my_progress_bar.dart';
import 'package:artisland/pages/profile/slider/profile_slider.dart';
import 'package:flutter/material.dart';

class ProfileActions extends StatefulWidget {
  @override
  _ProfileActionsState createState() => _ProfileActionsState();
}

class _ProfileActionsState extends State<ProfileActions> {
  bool snackBarVisible = false;
  Widget _buildNewPostButton(context) {
    return !snackBarVisible
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () => addPost(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("new post",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      )),
                  SizedBox(width: 8),
                  Icon(Icons.school, color: Colors.deepOrange, size: 30)
                ],
              ),
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("new post",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      )),
                  SizedBox(width: 8),
                  Icon(Icons.school, color: Colors.deepOrange, size: 30)
                ],
              ),
            ),
          );
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).buttonColor, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [Text("follow"), SizedBox(width: 4), Icon(Icons.remove_red_eye_outlined)],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).buttonColor, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [Text("message"), SizedBox(width: 4), Icon(Icons.message)],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => ProfileSlider())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("view Art",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      )),
                  SizedBox(width: 8),
                  Icon(Icons.art_track_outlined, color: Colors.deepOrange, size: 30)
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("tutorials",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      )),
                  SizedBox(width: 8),
                  Icon(Icons.school, color: Colors.deepOrange, size: 30)
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: _buildNewPostButton(context))
      ],
    );
  }

  void addPost(context) async {
    PostData newPost = await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
      return NewPostPage(new PostData(), edit: Edit.none);
    }));
    if (newPost == null) return;

    newPost.owner = UserManager.user.uid;
    var progressController = new StreamController<double>.broadcast(onCancel: ScaffoldMessenger.of(context).hideCurrentSnackBar);
    PostManager.addStorePost(newPost, progressController);

    var pBar = new MyProgressBar(progressController.stream);
    if (mounted) setState(() => snackBarVisible = true);
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(
          content: pBar,
          duration: Duration(days: 20),
          behavior: SnackBarBehavior.fixed,
        ))
        .closed
        .then((value) {
      MyProgressBar.progress = 0;
      if (mounted) setState(() => snackBarVisible = false);
    });
  }
}
