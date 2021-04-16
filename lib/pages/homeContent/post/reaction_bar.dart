import 'package:artisland/domain/entities/comment.dart';
import 'package:artisland/domain/entities/llike.dart';
import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/pages/common/post/comment.dart';
import 'package:artisland/pages/common/post/hearts.dart';
import 'package:artisland/pages/homeContent/post/user_info_space.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReactionBar extends StatefulWidget {
  PostData postData;
  final List<Comment> myComments = [];
  String postId;

  ReactionBar(
    this.postData, {
    Key key,
  }) : super(key: key);

  @override
  _ReactionBarState createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar> {
  Like myLike;
  List<Comment> postComments = [];
  bool commenting = false;
  int editiedItemIndex = -1;
  TextEditingController _controller = TextEditingController();
  FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    myLike = Like(UserManager.user.uid, UserManager.user.fullName, UserManager.user.profileImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(border: Border(right: BorderSide(), bottom: BorderSide())),
          margin: EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Comments(
                widget.postData,
                style: TextStyle(color: Colors.black, fontSize: 18),
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 40),
              Hearts(widget.postData, style: TextStyle(color: Colors.black, fontSize: 18)),
              SizedBox(width: 30),
            ],
          ),
        ),
      ],
    );
  }
}
