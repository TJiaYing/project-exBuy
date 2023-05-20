import 'package:flutter/material.dart';
import 'package:ksafeapp/models/user.dart';

import 'chatscreen.dart';
import 'groupscreen.dart';
import 'settingscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "GPS";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      MainScreen(
        user: widget.user,
      ),
      ChatScreen(user: widget.user),
      GroupScreen(user: widget.user),
      SettingScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.share_location,
                ),
                label: "GPS"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                ),
                label: "Chat"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.groups,
                ),
                label: "Group"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: "Setting"),
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "GPS";
      }
      if (_currentIndex == 1) {
        maintitle = "Chat";
      }
      if (_currentIndex == 2) {
        maintitle = "Group";
      }
      if (_currentIndex == 3) {
        maintitle = "Setting";
      }
    });
  }
}
