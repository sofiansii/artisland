import 'package:artisland/pages/profile/actions.dart';
import 'package:artisland/pages/profile/profile_info.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
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
