import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/pages/common/post/comment.dart';
import 'package:artisland/pages/common/post/hearts.dart';
import 'package:artisland/pages/homeContent/post/user_info_space.dart';
import 'package:flutter/material.dart';

class PostOverlay extends StatefulWidget {
  final ScrollController _scrollController;

  final PostData post;
  PostOverlay(this._scrollController, this.post);
  @override
  _PostOverlayState createState() => _PostOverlayState();
}

class _PostOverlayState extends State<PostOverlay> {
  int index;
  void _updateIndex() {
    if ((widget._scrollController.offset / MediaQuery.of(context).size.width).round().clamp(0, widget.post.u8intImages.length - 1) != index)
      setState(() {
        index = (widget._scrollController.offset / MediaQuery.of(context).size.width).round().clamp(0, widget.post.u8intImages.length - 1);
      });
  }

  @override
  void initState() {
    super.initState();

    widget._scrollController.addListener(_updateIndex);
  }

  @override
  void dispose() {
    widget._scrollController.removeListener(_updateIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateIndex();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.white,
                      ),
                      onPressed: Navigator.of(context).pop),
                  Text(
                    "view art",
                    style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
                  )
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(widget.post.getTime(), textAlign: TextAlign.end, style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w300)),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${index + 1}/${widget.post.u8intImages.length}", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Comments(widget.post), SizedBox(width: 30), Hearts(widget.post)],
              ),
            )
          ],
        )
      ],
    );
  }

  void like() {
    setState(() {
      widget.post.liked = true;
    });

    PostManager.like(widget.post.id).then((value) {
      if (value != null) {
        setState(() {
          widget.post.likes.add(value);
        });
      } else {
        setState(() {
          widget.post.liked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong...")));
      }
    });
  }

  void unlike() {
    setState(() {
      widget.post.liked = false;
    });
    PostManager.unLike(widget.post.id).then((value) {
      if (value != null) {
        setState(() {
          widget.post.likes.remove(value);
        });
      } else {
        setState(() {
          widget.post.liked = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong...")));
      }
    });
  }


}
