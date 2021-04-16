import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/pages/profile/slider/post.dart';
import 'package:artisland/pages/profile/slider/post/post_overlay.dart';
import 'package:flutter/material.dart';

class PostSlider extends StatefulWidget {
  PostData post;
  PostSlider(this.post);
  @override
  PpostSlikerState createState() => PpostSlikerState();
}

class PpostSlikerState extends State<PostSlider> {
  ScrollController _scrollController = ScrollController();
  bool showControles = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => showControles = !showControles),
        child: Stack(children: [
          ListView(
            controller: _scrollController,
            physics: PageScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < widget.post.u8intImages.length; i++)
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(alignment: Alignment.center, children: [
                      Opacity(
                        opacity: showControles ? 0.4 : 1,
                        child: Image.memory(
                          widget.post.u8intImages[i],
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width - 20,
                        ),
                      ),
                      if (showControles && widget.post.description.isNotEmpty)
                        Positioned.fill(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.all(15).copyWith(right: 40),
                              padding: EdgeInsets.all(3),
                              child: Text(
                                widget.post.description,
                                maxLines: 4,
                                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                    ])),
            ],
          ),
          if (showControles) PostOverlay(_scrollController, widget.post)
        ]),
      ),
    );
  }
}
