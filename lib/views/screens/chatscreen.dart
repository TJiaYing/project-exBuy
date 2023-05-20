import 'package:flutter/material.dart';
import 'package:ksafeapp/models/user.dart';

import '../shared/mainmenu.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(title: const Text("Chat")),
          body: const Center(child: Text("Chat")),
          drawer: MainMenuWidget(
            user: widget.user,
          )),
    );
  }
}
