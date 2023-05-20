import 'package:flutter/material.dart';
import 'package:exbuy/models/user.dart';

//for buyer screen

class BuyerScreen extends StatefulWidget {
  final User user;
  const BuyerScreen({super.key, required this.user});

  @override
  State<BuyerScreen> createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Buyer";

  @override
  void initState() {
    super.initState();
    print("Buyer");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
    );
  }
}
