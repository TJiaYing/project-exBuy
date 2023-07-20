import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/catchdetials.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../myconfig.dart';
import '../buyer/billscreen.dart';

class SellerOrderDetailsScreen extends StatefulWidget {
  final User user;
  final Order order;
  const SellerOrderDetailsScreen({
    super.key,
    required this.order,
    required this.user,
  });

  @override
  State<SellerOrderDetailsScreen> createState() =>
      _SellerOrderDetailsScreenState();
}

class _SellerOrderDetailsScreenState extends State<SellerOrderDetailsScreen> {
  List<OrderDetails> orderdetailsList = <OrderDetails>[];
  late double screenHeight, screenWidth;
  double totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    loadorderdetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        actions: [
          IconButton(
            onPressed: () {
              // Handle accept button functionality here
              // You can call a function to perform the "accept" action
              acceptOrder();
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Column(children: [
        orderdetailsList.isEmpty
            ? Container()
            : Expanded(
                child: ListView.builder(
                    itemCount: orderdetailsList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(children: [
                          CachedNetworkImage(
                            width: screenWidth / 3,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${MyConfig().SERVER}/assets/catches/${orderdetailsList[index].catchId}.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Column(
                            children: [
                              Text(
                                orderdetailsList[index].catchName.toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ]),
                      );
                    }))
      ]),
    );
  }

  void loadorderdetails() {
    http.post(Uri.parse("${MyConfig().SERVER}/php/load_sellerorderdetails.php"),
        body: {
          "sellerid": widget.order.sellerId,
          "orderbill": widget.order.orderBill
        }).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['orderdetails'].forEach((v) {
            orderdetailsList.add(OrderDetails.fromJson(v));
          });
        } else {
          // status = "Please register an account first";
          // setState(() {});
        }
        setState(() {});
      }
    });
  }

  void acceptOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Do you want to accept this order?"),
          content: const Text("Every barter will charge RM2"),
          actions: [
            TextButton(
              onPressed: () {
                // Perform the accept order action here
                // For example, update the server to accept the order
                _acceptOrderOnServer();
                // Close the dialog
                Navigator.pop(context);
              },
              child: const Text("Accept"),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _acceptOrderOnServer() {
    // Implement the logic to accept the order on the server here
    // For example, you can make an HTTP request to update the order status
    // after accepting the order.

    // After successfully accepting the order on the server, navigate to the bill payment screen.
    // For example:
    // http.post(Uri.parse("${MyConfig().SERVER}/php/accept_order.php"), body: {
    //   "orderId": widget.order.orderId,
    // }).then((response) {
    //   // Handle the server response here
    //   // For example, show a toast message or update the UI based on the response.
    //   // ...

    //   // If the server response indicates a successful order acceptance,
    //   // navigate to the bill payment screen.
    //   if (response.statusCode == 200 && response.body == "success") {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => BillPaymentScreen(),
    //       ),
    //     );
    //   }
    // });

    // For demonstration purposes, let's assume the order acceptance is successful.
    // Simulate the navigation to the bill payment screen after a short delay.
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BillScreen(
            user: widget.user,
            totalprice: totalprice,
          ),
        ),
      );
    });
  }
}
