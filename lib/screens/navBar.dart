import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account.dart';
import 'addWorkout.dart';
import 'home.dart';

class NavBar extends StatelessWidget {
  final CupertinoTabController _tabController =
      CupertinoTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black38,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.black87,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: Colors.black38,
            ),
            activeIcon: Icon(
              Icons.add_circle,
              color: Colors.black87,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black38,
            ),
            activeIcon: Icon(
              Icons.person,
              color: Colors.black87,
              size: 35,
            ),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return Home();
            break;
          case 1:
            return AddWorkout();
            break;
          case 2:
            return Account();
            break;
          default:
            return Home();
            break;
        }
      },
    );
  }
}
