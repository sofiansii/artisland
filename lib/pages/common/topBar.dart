import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/firebase_services/auth/authentication_service.dart';
import 'package:artisland/pages/common/Colors.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final title;
  final int index;
  TopBar({this.title = "Artisland", this.index = -1});

  final Map<String, Icon> options = {"Sign out": Icon(Icons.logout, color: Colors.black), "Edit Profile": Icon(Icons.edit, color: Colors.black)};

  void signOut(BuildContext c) {
    AuthenticationService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Icon(Icons.branding_watermark, color: Theme.of(context).iconTheme.color),
          ),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center)),
          if (index == 1)
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: PopupMenuButton(
                    onSelected: (v) {
                      if (v == "Sign out") signOut(context);
                    },
                    offset: Offset(0, 40),
                    icon: CircleAvatar(
                      child: Icon(Icons.person_rounded),
                      backgroundColor: GCprimaryAcentNeon,
                    ),
                    itemBuilder: (c) {
                      return [
                        for (var option in options.keys)
                          PopupMenuItem(
                            value: option,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(flex: 1, child: Container(child: options[option])),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    option,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ];
                    },
                  )),
            ),
        ],
      ),
    );
  }
}
