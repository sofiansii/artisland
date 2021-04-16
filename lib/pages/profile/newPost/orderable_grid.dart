import 'dart:typed_data';

import 'package:artisland/domain/image/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class OrderAbleGrid extends StatefulWidget {
  List<Uint8List> images;
  bool canAdd;
  Future<List<Uint8List>> Function() onAdd;
  OrderAbleGrid(this.images, {this.canAdd = false, this.onAdd});

  @override
  _OrderAbleGridState createState() => _OrderAbleGridState();
}

class _OrderAbleGridState extends State<OrderAbleGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 9, left: 9, bottom: 9, top: 2),
      decoration: BoxDecoration(border: Border.all()),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          if (widget.canAdd)
            Container(
              decoration: BoxDecoration(border: Border.all()),
              margin: EdgeInsets.all(12),
              width: ((MediaQuery.of(context).size.width - 20) / 3) - 22 - 2,
              child: AspectRatio(
                aspectRatio: 1,
                child: IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.add_photo_alternate_outlined, color: Theme.of(context).accentColor),
                  onPressed: _onAddClick,
                ),
              ),
            ),
          for (int i = 0; i < widget.images.length; i++)
            DragTarget(
              builder: (context, _, __) {
                var image = constructImageWidget(widget.images[i]);

                return Draggable<int>(
                  child: image,
                  feedback: image,
                  data: i,
                );
              },
              onAccept: (data) {
                setState(() {
                  var _tmp = widget.images[data];
                  widget.images[data] = widget.images[i];
                  widget.images[i] = _tmp;
                });
              },
              onWillAccept: (_) => true,
            )
        ],
      ),
    );
  }

  Material constructImageWidget(Uint8List i) {
    print("percect: " +
        "${2 * (((MediaQuery.of(context).size.width - 18) / 3) - 18) + ((MediaQuery.of(context).size.width - 18) / 3) - 24 == (MediaQuery.of(context).size.width - 18 - 24 - 2 * 18)}");
    return Material(
      child: Container(
        padding: EdgeInsets.all(9),
        width: ((MediaQuery.of(context).size.width - 20) / 3),
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Image.memory(i, fit: BoxFit.contain),
                if (widget.canAdd)
                  Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () => setState(() {
                                widget.images.remove(i);
                              })))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onAddClick() {
    widget.onAdd().then((images) {
      widget.images.addAll(images);
    });
  }
}
