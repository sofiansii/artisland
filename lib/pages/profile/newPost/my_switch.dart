import 'package:flutter/material.dart';

class MySwitch extends StatefulWidget {
  bool private;
  final bool Function(bool) onChange;
  MySwitch(this.private, this.onChange);
  @override
  _MySwitchState createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("private post"),
        SizedBox(width: 30),
        Switch(
            value: widget.private,
            onChanged: (state) {
              widget.private = widget.onChange(state);
              setState(() {});
            })
      ],
    );
  }
}
