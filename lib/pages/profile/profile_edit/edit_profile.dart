import 'actions.dart';
import 'profile_info.dart';
import 'package:flutter/material.dart';

class ProfileEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileInfo(),
        SizedBox(
          height: 70,
        ),
        Expanded(child: ProfileActions())
      ],
    );
  }
}
