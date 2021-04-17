import 'dart:async';
import 'dart:math';
import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/pages/profile/newPost/new_post.dart';
import 'package:artisland/pages/profile/slider/my_progress_bar.dart';
import 'package:artisland/pages/profile/slider/posts_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProfileSlider extends StatefulWidget {
  @override
  _ProfileSliderState createState() => _ProfileSliderState();
}

class _ProfileSliderState extends State<ProfileSlider> {
  StreamController<List<int>> info = StreamController<List<int>>();
  List<PostData> posts = [];
  ScrollController _scrollController;
  bool showControles = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    getUserPosts();
    super.initState();
  }

  Future<List<PostData>> getUserPosts() async {
    posts = (await PostManager.getPersonalPosts());
    return posts;
  }

  _close() => info.close();

  void _onPageChanged(int index, reason) {
    info.add([Random().nextInt(3000), index]);
    print(index);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("building");
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: getUserPosts(),
        initialData: null,
        builder: (c, snp) {
          if (snp.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          return GestureDetector(
            onTap: () => setState(() => showControles = !showControles),
            child: Stack(children: [
              ListView(
                controller: _scrollController,
                physics: PageScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  for (var i = 0; i < posts.length; i++)
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(alignment: Alignment.center, children: [
                          Opacity(
                            opacity: showControles ? 0.4 : 1,
                            child: Image.memory(
                              posts[i].u8intImages[0],
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width - 20,
                            ),
                          ),
                          if (showControles && posts[i].description.isNotEmpty)
                            Positioned.fill(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.all(15).copyWith(right: 40),
                                  padding: EdgeInsets.all(3),
                                  child: Text(
                                    posts[i].description,
                                    maxLines: 4,
                                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                        ])),
                ],
              ),
              if (showControles) PostsOverlay(_scrollController, posts, editPost, deletePost)
            ]),
          );
        },
      ),
    );
  }

  void addPost() async {
    PostData newPost = await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
      return NewPostPage(new PostData(), edit: Edit.none);
    }));
    if (newPost == null) return;

    for (int i = 0; i < 30; i++) {
      newPost.owner = UserManager.user.uid;
      var progressController = new StreamController<double>.broadcast(onCancel: ScaffoldMessenger.of(context).hideCurrentSnackBar);
      PostManager.addStorePost(newPost, progressController);

      var pBar = new MyProgressBar(progressController.stream);
      ScaffoldMessenger.of(context)
          .showSnackBar(new SnackBar(
            content: pBar,
            duration: Duration(days: 20),
            behavior: SnackBarBehavior.fixed,
          ))
          .closed
          .then((value) => MyProgressBar.progress = 0);
    }
  }

  void editPost(int index) async {
    var time = (Timestamp.now().millisecondsSinceEpoch - posts[index].time.millisecondsSinceEpoch) / (1000 * 3600);
    PostData newPost;
    if (time < 24) {
      newPost = await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
        return NewPostPage(posts[index], edit: Edit.early);
      }));
      if (newPost == null) return;

      newPost.owner = UserManager.user.uid;
      final StreamController progressController = StreamController<double>.broadcast(onCancel: ScaffoldMessenger.of(context).hideCurrentSnackBar);
      PostManager.editPost(newPost, progressController).then((value) {
        if (!value) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong...")));
          return;
        } else {
          if (mounted)
            setState(() {
              posts[index] = newPost;
            });
        }
      });

      var pBar = MyProgressBar(progressController.stream);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: pBar, duration: Duration(days: 20), behavior: SnackBarBehavior.fixed))
          .closed
          .then((value) => MyProgressBar.progress = 0);
    } else {
      print("edit");
      newPost = await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
        return NewPostPage(posts[index], edit: Edit.late);
      }));
      if (newPost == null) return;

      PostManager.lateEditPost(newPost).then((value) {
        if (value) {
          setState(() => posts[index] = newPost);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong...")));
        }
      });
    }
  }

  void deletePost(i) async {
    var post = posts.removeAt(i);
    setState(() {});
    PostManager.deletePost(post.id).then((value) {
      if (!value) {
        setState(() {
          posts.insert(i, post);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong...")));
        });
      }
    });
  }
}

class PostInfo extends StatefulWidget {
  final Stream<List<int>> info;

  const PostInfo({Key key, @required this.info}) : super(key: key);

  @override
  _PostInfoState createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  int time = 0, likes = 0, comments = 10;

  void _onUpdate(newData) {
    setState(() {
      likes = newData.first;
      time = newData.last;
    });
  }

  final Color textColor = Colors.black;
  @override
  void initState() {
    widget.info.listen(_onUpdate, cancelOnError: false, onDone: () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Comments: $comments", style: TextStyle(color: textColor)),
        SizedBox(width: 30),
        Text("Likes: ", style: TextStyle(color: textColor)),
        SizedBox(width: 4),
        Text("$likes", style: TextStyle(color: textColor)),
        SizedBox(width: 30),
        Text("$time d", style: TextStyle(color: textColor)),
      ],
    );
  }
}
