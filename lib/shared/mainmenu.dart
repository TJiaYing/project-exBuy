import 'package:flutter/material.dart';
import 'package:exbuy/models/user.dart';
import 'package:exbuy/screens/mainscreen.dart';
import 'package:exbuy/shared/EnterExitRoute.dart';

import '../screens/sellerscreen.dart';
import '../screens/profilescreen.dart';

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
            title: const Text('Buyer'),
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
            title: const Text('Seller'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: SellerScreen(
                        user: widget.user,
                      ),
                      enterPage: SellerScreen(
                        user: widget.user,
                      )));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: ProfileScreen(
                        user: widget.user,
                      ),
                      enterPage: ProfileScreen(
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
