import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String uid;
  String comment;
  String name;
  String image;
  Timestamp time;
  int n;
  bool isPinned = false;
  String id;
  String postId;

  String getTime() {
    var timeDiff =
        (Timestamp.now().millisecondsSinceEpoch - time.millisecondsSinceEpoch) /
            (1000).floor();
    var timeDiffString = "";
    if (timeDiff < 60)
      timeDiffString = "${timeDiff.floor()} s";
    else if (timeDiff < 3600)
      timeDiffString = "${(timeDiff / 60).floor()} m";
    else if (timeDiff < 3600 * 24)
      timeDiffString = "${(timeDiff / (3600)).floor()} h";
    else if (timeDiff < 3600 * 24 * 7 || timeDiff > 3600 * 24 * 30)
      timeDiffString = "${(timeDiff / (3600 * 24)).floor()} d";
    else if (timeDiff < 3600 * 24 * 30)
      timeDiffString = "${(timeDiff / (3600 * 24 * 7)).floor()} w";
    return timeDiffString;
  }
}
