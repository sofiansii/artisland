import 'dart:math';

import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/pages/common/Colors.dart';
import 'package:artisland/pages/profile/slider/profile_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatefulWidget {
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  double getProfileLikesspacing() => 40;
  var gradientColor = [Color(0xff352131), Color(0xff35244a)];

  String description() {
    var text =
        "a little ugly discription a little ugly discription a little ugly discription a little asdasdadasd discription a little ugly discription lorem  a little ugly discription a little ugly 5discription a4 little   ;a;a";

    return text;
  }

  String profileName = "Soufian Moulay";

  Widget getProfile() {
    var url = UserManager.user.profileImage;
    print("urls is " + url);
    return Image.network(url);
    return url != null
        ? CircleAvatar(
            minRadius: 56,
            maxRadius: 56,
            backgroundImage: NetworkImage(url),
          )
        : CircleAvatar(
            minRadius: 35,
            child: Icon(
              Icons.person,
              size: 30,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Card(
        color: GCprimaryNeon,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Column(
              children: [
                Card(
                  child: Container(height: 200, decoration: BoxDecoration(gradient: LinearGradient(colors: gradientColor))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: getProfileLikesspacing(),
                      // child: Container(
                      //   margin:
                      //       EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       primary:
                      //           Theme.of(context).buttonColor, // background
                      //       onPrimary: Colors.white, // foreground
                      //     ),
                      //     onPressed: () {},
                      //     child: Row(
                      //       children: [
                      //         Text("follow"),
                      //         SizedBox(width: 2),
                      //         Icon(Icons.remove_red_eye_outlined)
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    )
                  ],
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    width: 112,
                    height: 112,
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        getProfile(),
                        Opacity(opacity: 0.5, alwaysIncludeSemantics: true, child: Container(height: 112, width: 112, color: Colors.black)),
                        GestureDetector(
                          onTap: () => print("tapped"),
                          child: Container(
                            padding: EdgeInsets.all(40),
                            child: Icon(
                              Icons.photo_library_sharp,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: Colors.black, width: 1),
              )),
          padding: EdgeInsets.only(right: 70, left: 4),
          width: MediaQuery.of(context).size.width,
          child: Text(description(),
              maxLines: 3,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ))),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [WatchText("following"), SizedBox(height: 2), WatchNumber(Random().nextInt(33000))],
                ),
              ),
            ),
          ),
          SizedBox(width: 2),
          Expanded(
            child: Card(
              margin: EdgeInsets.fromLTRB(5, 0, 20, 0),
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [WatchText("follower"), SizedBox(height: 2), WatchNumber(20)],
                ),
              ),
            ),
          )
        ],
      ),
    ]);
  }
}

class WatchNumber extends StatelessWidget {
  final int number;
  const WatchNumber(
    this.number, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("$number", style: TextStyle(fontSize: 20, color: Colors.black));
  }
}

class WatchText extends StatelessWidget {
  final text;

  const WatchText(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 15, color: Colors.black),
    );
  }
}
