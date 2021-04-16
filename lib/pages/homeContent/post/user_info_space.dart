import 'package:flutter/material.dart';

class UserInfoSpace extends StatelessWidget {
  final String image, name;
  const UserInfoSpace(
    this.name,
    this.image, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          foregroundImage: NetworkImage(image),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(name,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.grey[700], fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }
}
