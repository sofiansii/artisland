import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/pages/homeContent/post/user_info_space.dart';
import 'package:flutter/material.dart';

enum HearState { active, loading, inactive }

class Hearts extends StatefulWidget {
  final PostData post;
  final double size;

  final TextStyle style;
  final EdgeInsetsGeometry padding;
  const Hearts(
    this.post, {
    this.padding = const EdgeInsets.all(8),
    this.style = const TextStyle(fontSize: 20, color: Colors.white),
    this.size = 20,
    Key key,
  }) : super(key: key);

  @override
  _HeartsState createState() => _HeartsState();
}

class _HeartsState extends State<Hearts> {
  HearState heartState;
  @override
  void initState() {
    heartState = widget.post.liked ? HearState.active : HearState.inactive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var icon = heartState == HearState.loading
        ? Container(
            child: CircularProgressIndicator(strokeWidth: 2),
            padding: EdgeInsets.all(2),
            width: widget.size,
            height: widget.size,
            alignment: Alignment.center,
          )
        : heartState == HearState.inactive
            ? Icon(Icons.favorite_border, size: widget.size, color: Colors.redAccent)
            : Icon(Icons.favorite, size: widget.size, color: Colors.redAccent);
    return Row(
      children: [
        InkWell(
          onTap: showLikesList,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("${widget.post.likes.length}", style: widget.style),
          ),
        ),
        GestureDetector(onTap: showLikesList, child: SizedBox(width: 2)),
        InkWell(onTap: widget.post.liked ? unlike : like, child: Padding(padding: widget.padding, child: icon)),
      ],
    );
  }

  void like() {
    setState(() {
      widget.post.liked = true;
      heartState = HearState.loading;
    });

    PostManager.like(widget.post.id).then((value) {
      if (value != null) {
        setState(() {
          widget.post.likes.add(value);
          heartState = HearState.active;
        });
      } else {
        setState(() {
          widget.post.liked = false;
          heartState = HearState.inactive;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong...")));
      }
    });
  }

  void unlike() {
    setState(() {
      widget.post.liked = false;
      heartState = HearState.loading;
    });
    PostManager.unLike(widget.post.id).then((value) {
      if (value != null) {
        setState(() {
          widget.post.likes.remove(value);
          heartState = HearState.inactive;
        });
      } else {
        setState(() {
          widget.post.liked = true;
          heartState = HearState.active;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("something went wrong...")));
      }
    });
  }

  showLikesList() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            for (var like in widget.post.likes)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserInfoSpace(like.name, like.image),
                  ),
                  SizedBox(height: 1, child: ColoredBox(color: Colors.grey[300]))
                ],
              )
          ],
        );
      },
    );
  }
}
