import 'package:artisland/domain/entities/comment.dart';
import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/pages/common/topBar.dart';

import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  final BuildContext c;
  final PostData postData;
  CommentPage(this.postData, this.c);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  int editing = -1;
  var image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAp-X6qZnvz-hHgz6rnB8MDA_sSLd_IALjgg&usqp=CAU";

  Widget _itemBuilder(BuildContext c, i) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 17),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(widget.postData.comments[i].name, style: TextStyle(color: Colors.grey[700], fontSize: 17, fontWeight: FontWeight.w400)),
              ),
            ),
            Text(widget.postData.comments[i].getTime(), style: TextStyle(color: Colors.grey[400]))
          ],
        ),
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10).copyWith(top: 0),
          child: Text(widget.postData.comments[i].comment, textAlign: TextAlign.start, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w400))),
      if (widget.postData.comments[i].uid == UserManager.user.uid)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    // primary: Colors.white,
                    // shadowColor: Colors.grey,
                    backgroundColor: Colors.white10),
                onPressed: () {
                  editing = i;
                  _controller.text = widget.postData.comments[i].comment;
                  focusNode.requestFocus();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.black),
                      Text(
                        "edit",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                )),
            TextButton(
                style: TextButton.styleFrom(
                    // primary: Colors.white,
                    // shadowColor: Colors.grey,
                    backgroundColor: Colors.white10),
                onPressed: () => deleteComment(widget.postData.comments[i]),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.black),
                      Text(
                        "delete",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                )),
          ],
        ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(width: double.infinity, height: 1, child: ColoredBox(color: Colors.grey[300])),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TopBar()),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: focusNode.unfocus,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.postData.comments.length,
                  itemBuilder: (c, i) => _itemBuilder(c, i),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  focusNode: focusNode,
                  maxLines: 4,
                  controller: _controller,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                      focusColor: Colors.red,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: "add Comment..."),
                )),
                IconButton(
                    icon: Icon(Icons.send, color: Theme.of(context).accentColor),
                    onPressed: () {
                      if (editing == -1)
                        addNewComment(_controller.text);
                      else
                        editComment(widget.postData.comments[editing]..comment = _controller.text);
                      editing = -1;
                      _controller.clear();
                    })
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<List<Comment>> loadNewComments() async {
    var newComments = await PostManager.getPostCmments(widget.postData.id, newestComment: widget.postData.comments.length > 0 ? widget.postData.comments.first : null);
    widget.postData.comments.insertAll(0, newComments);
    setState(() {});
    return widget.postData.comments;
  }

  void addNewComment(String comment) {
    PostManager.addComment(widget.postData.id, comment, widget.postData.comments.length > 0 ? widget.postData.comments.first : null).then((value) {
      if (!value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("comment could not be added")));
      } else {
        loadNewComments();
      }
    }).onError((error, stackTrace) {
      PostManager.printError(error, stackTrace);
    });
  }

  void editComment(Comment comment) {
    PostManager.editComment(comment).then((value) {
      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("comment could not be edited")));
      } else {
        setState(() {
          widget.postData.comments[widget.postData.comments.indexOf(comment)] = value;
        });
      }
    });
  }

  void deleteComment(Comment comment) {
    PostManager.deleteComment(comment).then((value) {
      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("comment could not be deleted")));
      } else {
        setState(() {
          widget.postData.comments.remove(comment);
        });
      }
    });
  }
}
