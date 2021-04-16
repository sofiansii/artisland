import 'dart:math';

import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/pages/common/Colors.dart';
import 'package:artisland/pages/common/pen_widget.dart';
import 'package:artisland/pages/homeContent/home.dart';
import 'package:artisland/pages/common/topBar.dart';
import 'package:artisland/pages/profile/Profile.dart';
import 'package:artisland/pages/profile/profile_edit/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefualtScaffold extends StatefulWidget {
  @override
  _DefualtScaffoldState createState() => _DefualtScaffoldState();
}

class _DefualtScaffoldState extends State<DefualtScaffold> with SingleTickerProviderStateMixin {
  TabController _controller;
  TopBar topBar;
  var actions = [Icons.home, Icons.person];
  double actionsWidth = 0;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    views = [new Home(), new ProfileEdit()];

    super.initState();
  }

  List<Widget> views = [];

  void _onDrawePress() {
    if (actionsWidth != 0)
      actionsWidth = 0;
    else
      actionsWidth = 60;

    setState(() {});
  }

  _tabBarView() {
    return AnimatedBuilder(
      animation: _controller.animation,
      builder: (BuildContext c, snp) {
        var height = MediaQuery.of(c).size.height;
        double multiplyVal = _controller.index - _controller.animation.value;
        return Transform.translate(
          offset: Offset(0, height * multiplyVal),
          child: IndexedStack(children: views, index: _controller.animation.value.round()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.height;
    var tabBar = TabBar(
        controller: _controller,
        onTap: (i) => setState(_onDrawePress),
        tabs: [for (var t in actions) Tab(icon: RotatedBox(quarterTurns: -1, child: Icon(t, color: Theme.of(context).iconTheme.color)))]);

    if (_controller.index == 1)
      topBar = TopBar(title: UserManager.user.fullName, index: _controller.index);
    else
      topBar = TopBar();
    return DefaultTabController(
        length: 4,
        child: GestureDetector(
          onTap: () {
            //hide any Keyboards
            FocusScope.of(context).unfocus();
            //hide navPen if visible
            if (actionsWidth != 0) _onDrawePress();
          },
          child: Scaffold(
            appBar: AppBar(title: topBar, actions: [
              IconButton(
                  icon: Icon(Icons.dehaze, color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    //hide any Keyboards
                    //FocusScope.of(context).unfocus();
                    _onDrawePress();
                  })
            ]),
            body: Stack(
              alignment: Alignment.centerRight,
              children: [
                _tabBarView(),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.fastOutSlowIn,
                  height: screenSize / 2,
                  width: actionsWidth,
                  child: PenArt(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(
                            4,
                            0,
                            0,
                            /*pen body 70%, pen head 30%*/ (screenSize / 2) * 0.3),
                        child: RotatedBox(quarterTurns: 1, child: tabBar)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
