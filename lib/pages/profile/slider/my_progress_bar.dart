import 'dart:async';
import 'package:flutter/material.dart';

class MyProgressBar extends StatefulWidget {
  final Stream<double> progressStream;
  static double progress = 0.0;
  MyProgressBar(this.progressStream);
  @override
  _MyProgressBarState createState() => _MyProgressBarState();
}

class _MyProgressBarState extends State<MyProgressBar> {
  StreamSubscription sub;

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    sub = widget.progressStream.listen((event) {
      MyProgressBar.progress = event;
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(value: MyProgressBar.progress);
  }
}
