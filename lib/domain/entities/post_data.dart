import 'dart:typed_data';

import 'package:artisland/domain/entities/comment.dart';
import 'package:artisland/domain/entities/llike.dart';
import 'package:artisland/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostData {
  String id;
  String owner;
  List<Image> images = [];
  List<Uint8List> u8intImages = [];
  List<double> aspects = [];
  String description = "";
  bool private = false;
  List<Comment> comments = [];
  List<Like> likes = [];
  bool liked = false;
  bool isPinned = false;
  Timestamp time;

  String getTime() {
    var timeDiff = (Timestamp.now().millisecondsSinceEpoch - time.millisecondsSinceEpoch) / (1000).floor();
    var timeDiffString = "";
    if (timeDiff < 60)
      timeDiffString = "${timeDiff.floor()} s";
    else if (timeDiff < 3600)
      timeDiffString = "${(timeDiff / 60).floor()} m";
    else if (timeDiff < 3600 * 24)
      timeDiffString = "${(timeDiff / (3600)).floor()} h";
    else if (timeDiff < 3600 * 24 * 7 || timeDiff > 3600 * 24 * 30)
      timeDiffString = "${(timeDiff / (3600 * 24)).floor()} d";
    else if (timeDiff < 3600 * 24 * 30) timeDiffString = "${(timeDiff / (3600 * 24 * 7)).floor()} w";
    return timeDiffString;
  }
}
