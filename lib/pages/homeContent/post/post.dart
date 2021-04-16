import 'dart:math';

import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/pages/homeContent/post/reaction_bar.dart';
import 'package:artisland/pages/homeContent/post/user_info_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class Post extends StatelessWidget {
  final PostData postData;
  Image getImage(context, i) {
    if (postData.images.length == 0 || postData.images.length == i)
      postData.images.add(Image.memory(postData.u8intImages[i], width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth));
    return postData.images[i];
  }

  Post(this.postData);

  Widget getSlider(context) {
    // print(
    // "aspect: ${getImage(context, 0).width / getImage(context, 0).height}");
    var sl = ListView(
      children: [for (int i = 0; i < postData.u8intImages.length; i++) AspectRatio(aspectRatio: 4 / 5, child: getImage(context, i))],

      //controller: FixedExtentScrollController(initialItem: 0),
      itemExtent: MediaQuery.of(context).size.width - 18,
      scrollDirection: Axis.horizontal,
      physics: PageScrollPhysics(),
    );
    return sl;
  }

  final color = Colors.blue[800];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [Colors.white, Colors.grey[200]])),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(alignment: Alignment.bottomRight, children: [
              UserInfoSpace(UserManager.user.fullName, UserManager.user.profileImage),
              Text(postData.getTime(), textAlign: TextAlign.end, style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))
            ]),
          ),
          //desctiption
          if (postData.description.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(postData.description, style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 17.7, color: Colors.grey[700], fontWeight: FontWeight.w300)),
            ),
          //main image
          Container(
            decoration: BoxDecoration(border: Border.all()),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: AspectRatio(aspectRatio: postData.aspects.reduce(min), child: getSlider(context)),
          ),

          ReactionBar(postData),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
