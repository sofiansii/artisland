import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/pages/comment_section/comment_section.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  final PostData post;
  final TextStyle style;
  final double size;
  final Color color;
  const Comments(this.post, {this.style = const TextStyle(fontSize: 17, color: Colors.white), this.size = 20, this.color = Colors.white});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    showCommentsList() {
      Navigator.of(context).push(MaterialPageRoute(builder: (c) => CommentPage(widget.post, context))).then((c) {
        if (mounted) setState(() {});
      });
    }

    return GestureDetector(
        onTap: showCommentsList,
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${widget.post.comments.length}", style: widget.style),
          ),
          SizedBox(width: 6, height: 20),
          InkWell(
            onTap: showCommentsList,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.comment, size: widget.size, color: widget.color),
            ),
          )
        ]));
  }
}
