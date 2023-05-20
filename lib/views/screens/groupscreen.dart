import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ksafeapp/models/user.dart';
import 'package:ksafeapp/models/member.dart';
import 'package:ksafeapp/views/screens/loginscreen.dart';
import 'package:ksafeapp/views/screens/registrationscreen.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

import '../../config.dart';
import '../shared/mainmenu.dart';
import 'addmembersscreen.dart';

class GroupScreen extends StatefulWidget {
  final User user;
  const GroupScreen({super.key, required this.user});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Member> memberList = <Member>[];
  String member = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  var color;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  //for pagination

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadMembers("all", 1);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Group Members"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _loadSearch();
              },
            ),
            PopupMenuButton<int>(
              onSelected: (value) {
                if (value == 0) {
                  _gotoAddMembers();
                  print("Add member");
                } else if ((value == 1)) {
                  print("Setting member");
                } else if (value == 2) {
                  print("Delete member");
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Add Members"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text('Setting'),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: memberList.length,
          itemBuilder: (context, index) {
            Member member = memberList[index];
            return ListTile(
              leading: CircleAvatar(
                // Display the member's profile picture here
                backgroundImage: NetworkImage(member.profilePicture ?? ""),
              ),
              title: Text(member.name ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.phoneNumber ?? ""),
                  Text('Role: ${member.role ?? ""}'),
                ],
              ),
            );
          },
        ),
        drawer: MainMenuWidget(user: widget.user),
      ),
    );
  }

  void _registrationForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void _loginForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  void _gotoAddMembers() {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account with us",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const AddMembersScreen()));
  }

  void _loadSearch() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //return object of type Dialog
        return AlertDialog(
          title: const Text(
            "Search",
          ),
          content: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)))),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                String phoneNumber = searchController.text;
                _loadMembers(phoneNumber, 1);
              },
              child: const Text("Search"),
            ),
          ],
        );
      },
    ).then((_) {
      _addmembers();
    });
  }

  void _addmembers() {
    String selectedRole = "Parent"; //Default role is set as parent
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Add Member"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Member Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedRole,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                    items: <String>['Parent', 'Child'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    String memberName = searchController.text;
                    String memberRole = selectedRole;
                    // Perform the necessary operations to add the member
                    // Add your code here to add the member to the database or perform any other required actions
                    // ...
                    // Optionally, you can refresh the member list or perform any UI updates
                    // ...
                  },
                  child: const Text("Add"),
                )
              ],
            );
          });
        });
  }

  void _loadMembers(String search, int pageno) {
    curpage = pageno; //init current page
    numofpage;

    http
        .get(
      Uri.parse(
          "${Config.SERVER}/php/loadmembers.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        title: null,
        blur: 5,
        message: const Text("Loading..."),
      );
      progressDialog.show();
      //wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array

          if (extractdata['members'] != null) {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata[
                'numberofresult']); //get total number of result returned
            //check if  array object is not null
            memberList = <Member>[]; //complete the array object definition
            extractdata['products'].forEach((v) {
              //traverse products array list and add to the list object array productList
              memberList.add(Member.fromJson(
                  v)); //add each product array to the list object array productList
            });
            member = "Found";
          } else {
            member =
                "No Friends Available"; //if no data returned show title center
            memberList.clear();
          }
        }
      } else {
        member = "No Friends Available"; //status code other than 200
        memberList.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
      progressDialog.dismiss();
    });
  }
}
