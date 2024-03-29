import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/catch.dart';
import '../../models/user.dart';
import '../../myconfig.dart';
import 'buyerdetialscreen.dart';

class BuyerMoreScreen extends StatefulWidget {
  final Catch usercatch;
  final User user;
  const BuyerMoreScreen(
      {super.key, required this.usercatch, required this.user});

  @override
  State<BuyerMoreScreen> createState() => _BuyerMoreScreenState();
}

class _BuyerMoreScreenState extends State<BuyerMoreScreen> {
  List<Catch> catchList = <Catch>[];
  int numberofresult = 0;
  late double screenHeight, screenWidth, cardwitdh;
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");

  @override
  void initState() {
    super.initState();
    loadSellerItems();
    loadSeller();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("More from ")),
      body: Column(
        children: [
          SizedBox(
              height: screenHeight / 8,
              width: screenWidth,
              child: Card(
                  child: user.name == "na"
                      ? const Center(child: Text("Loading..."))
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Store Owner\n${user.name}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))),
          const Divider(),
          catchList.isEmpty
              ? Container()
              : Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(catchList.length, (index) {
                        return Card(
                          child: InkWell(
                            onTap: () async {
                              Catch usercatch =
                                  Catch.fromJson(catchList[index].toJson());
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => BuyerDetailsScreen(
                                            user: widget.user,
                                            usercatch: usercatch,
                                            page: 1,
                                          )));
                              //loadCatches();
                            },
                            child: Column(children: [
                              CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${MyConfig().SERVER}/assets/catches/${catchList[index].catchId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Text(
                                catchList[index].catchName.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                "RM ${double.parse(catchList[index].catchPrice.toString()).toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${catchList[index].catchQty} available",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ]),
                          ),
                        );
                      })))
        ],
      ),
    );
  }

  void loadSellerItems() {
    http.post(Uri.parse("${MyConfig().SERVER}/php/load_singleseller.php"),
        body: {
          "sellerid": widget.usercatch.userId,
        }).then((response) {
      //print(response.body);
      //log(response.body);
      catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['catches'].forEach((v) {
            catchList.add(Catch.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  void loadSeller() {
    http.post(Uri.parse("${MyConfig().SERVER}/php/load_user.php"), body: {
      "userid": widget.usercatch.userId,
    }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }
}
