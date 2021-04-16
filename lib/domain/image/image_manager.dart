import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';

abstract class ImageManager {
  static Future<Uint8List> cropImage(Uint8List uInt8Image) async {
    String dir = (await getTemporaryDirectory()).path;
    File temp = new File('$dir/temp.file');
    await temp.writeAsBytes(uInt8Image.toList());
    temp = await ImageCropper.cropImage(
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio5x7,
        CropAspectRatioPreset.ratio4x5,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio16x9,
      ],
      sourcePath: temp.absolute.path,
      maxHeight: 1360,
      maxWidth: 1080,
      androidUiSettings: AndroidUiSettings(
        lockAspectRatio: true,
        hideBottomControls: false,
      ),
    );
    if (temp == null) return null;

    var croppedUintImage = temp.readAsBytes();
    temp.delete();
    return croppedUintImage;
  }

  static Future<Image> assetToImage(Uint8List uInt8Image) async {
    return Image.memory(
      uInt8Image,
      fit: BoxFit.fitWidth,
    );
  }

  static Future<List<int>> getDementionsFromAsset(Uint8List image) async {
    var imageDescriptor = await ImageDescriptor.encoded(await ImmutableBuffer.fromUint8List(image));
    return [imageDescriptor.height, imageDescriptor.width];
  }
}
