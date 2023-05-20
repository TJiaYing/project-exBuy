import 'package:flutter/material.dart';
import 'package:ksafeapp/models/user.dart';
import 'package:ksafeapp/views/screens/mainscreen.dart';
import 'package:ksafeapp/views/shared/EnterExitRoute.dart';

import '../screens/chatscreen.dart';
import '../screens/groupscreen.dart';
import '../screens/settingscreen.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  late double screenHeight;
  var pathAsset = "assets/images/cover.png";
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountEmail: Text("Unregistered"),
            accountName: Text("Unregistered"),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
            ),
          ),
          ListTile(
            title: const Text('GPS'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: MainScreen(
                        user: widget.user,
                      ),
                      enterPage: MainScreen(
                        user: widget.user,
                      )));
            },
          ),
          ListTile(
            title: const Text('Group'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: GroupScreen(
                        user: widget.user,
                      ),
                      enterPage: GroupScreen(
                        user: widget.user,
                      )));
            },
          ),
          ListTile(
            title: const Text('Chat'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: ChatScreen(
                        user: widget.user,
                      ),
                      enterPage: ChatScreen(
                        user: widget.user,
                      )));
            },
          ),
          ListTile(
            title: const Text('Setting'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: SettingScreen(
                        user: widget.user,
                      ),
                      enterPage: SettingScreen(
                        user: widget.user,
                      )));
            },
          ),
          const Divider(
            color: Colors.purple,
          ),
          SizedBox(
            height: screenHeight / 2.3,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text("Version 0.1b")],
            ),
          )
        ],
      ),
    );
  }
}
