import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:artisland/domain/entities/comment.dart';
import 'package:artisland/domain/entities/llike.dart';
import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/image/image_manager.dart';
import 'package:artisland/pages/common/topBar.dart';
import 'package:artisland/pages/profile/newPost/my_switch.dart';
import 'package:artisland/pages/profile/newPost/orderable_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

enum Edit { late, early, none }

class NewPostPage extends StatefulWidget {
  PostData postData;
  PostData originalPostData;

  Edit edit;
  NewPostPage(this.originalPostData, {@required this.edit}) {
    if (edit != Edit.none)
      postData = new PostData()
        ..id = originalPostData.id
        ..owner = originalPostData.owner
        ..description = originalPostData.description
        ..images = new List<Image>.from(originalPostData.images)
        ..u8intImages = new List<Uint8List>.from(originalPostData.u8intImages)
        ..private = originalPostData.private
        ..isPinned = originalPostData.isPinned
        ..aspects = new List<double>.from(originalPostData.aspects)
        ..comments = new List<Comment>.from(originalPostData.comments)
        ..likes = new List<Like>.from(originalPostData.likes)
        ..liked = originalPostData.liked
        ..time = Timestamp.fromMicrosecondsSinceEpoch(originalPostData.time.microsecondsSinceEpoch);
    else
      postData = originalPostData;
  }

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  TextEditingController _descriptionController = TextEditingController();
  FocusNode focusNode = new FocusNode();
  bool hasPendingWork = false;

  @override
  void initState() {
    if (widget.edit != Edit.none) _descriptionController.text = widget.postData.description;

    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buidldUi() {
    return GestureDetector(
      onTap: focusNode.unfocus,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 4),
              child: Text(
                "Images",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                "drag and drop to reorder",
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100),
                child: widget.edit != Edit.late ? OrderAbleGrid(widget.postData.u8intImages, canAdd: true, onAdd: newImages) : OrderAbleGrid(widget.postData.u8intImages)),
            SizedBox(height: 8),
            TextField(
              focusNode: focusNode,
              controller: _descriptionController,
              maxLines: 4,
              minLines: 1,
              maxLength: 150,
              style: TextStyle(fontSize: 16),
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              scrollPhysics: NeverScrollableScrollPhysics(),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor)), hintText: "add Description", border: OutlineInputBorder()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MySwitch(widget.postData.private, (value) => widget.postData.private = value),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("cancel"),
                      )),
                  ElevatedButton(
                      onPressed: onPost,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("post"),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: Container(), title: TopBar()),
        body: !hasPendingWork
            ? _buidldUi()
            : Stack(
                children: [IgnorePointer(child: Opacity(opacity: .5, child: _buidldUi())), if (hasPendingWork) Center(child: CircularProgressIndicator())],
              ));
  }

  void onPost() {
    if (widget.postData.u8intImages.length > 0)
      Navigator.of(context).pop(widget.postData..description = _descriptionController.text);
    else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("at least one image is required"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<List<Uint8List>> newImages() async {
    var assets = await MultiImagePicker.pickImages(
      maxImages: 6 - widget.postData.u8intImages.length,
      enableCamera: true,
      selectedAssets: [],
      cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
      materialOptions: MaterialOptions(
        actionBarTitle: "pick up to 6 images",
        allViewTitle: "All Photos",
        useDetailsView: true,
        selectCircleStrokeColor: "#ffffff",
      ),
    );
    List<Uint8List> images = [];
    setState(() => hasPendingWork = true);
    for (var newAsset in assets) {
      var res = await ImageManager.cropImage((await newAsset.getByteData()).buffer.asUint8List());
      if (res != null) images.add(res);
    }
    setState(() => hasPendingWork = false);

    return images;
  }
}
