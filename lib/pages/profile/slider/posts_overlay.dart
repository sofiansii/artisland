import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/pages/common/post/comment.dart';
import 'package:artisland/pages/common/post/hearts.dart';
import 'package:artisland/pages/homeContent/post/user_info_space.dart';
import 'package:artisland/pages/profile/slider/post/post_slider.dart';
import 'package:flutter/material.dart';

class PostsOverlay extends StatefulWidget {
  final Function(int) onEdit;
  final Function(int) onDelete;
  final ScrollController _scrollController;

  final List<PostData> posts;
  PostsOverlay(this._scrollController, this.posts, this.onEdit, this.onDelete);
  @override
  _PostOverlayState createState() => _PostOverlayState();
}

class _PostOverlayState extends State<PostsOverlay> {
  int index;
  void _updateIndex() {
    if ((widget._scrollController.offset / MediaQuery.of(context).size.width).round().clamp(0, widget.posts.length - 1) != index)
      setState(() {
        index = (widget._scrollController.offset / MediaQuery.of(context).size.width).round().clamp(0, widget.posts.length - 1);
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
    if (widget.posts.length == 0) return Container();
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
                    "art slider",
                    style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
                  )
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(widget.posts[index].getTime(), textAlign: TextAlign.end, style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w300)),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        //bottom
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("1/${widget.posts[index].u8intImages.length}", style: TextStyle(color: Colors.white)),
                  InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => PostSlider(widget.posts[index]))),
                      child: Text("show all", style: Theme.of(context).textTheme.button.copyWith(color: Colors.white))),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Comments(widget.posts[index]), SizedBox(width: 30), Hearts(widget.posts[index])],
                )),
            if (widget.posts[index].owner == UserManager.user.uid)
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          splashRadius: 20.1,
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                          onPressed: () => widget.onDelete(index)),
                      IconButton(
                        splashRadius: 20.1,
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () => widget.onEdit(index),
                      )
                    ],
                  ),
                ),
              )
            else
              Container(margin: EdgeInsets.only(bottom: 20)),
          ],
        )
      ],
    );
  }
}
