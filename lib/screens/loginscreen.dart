import 'dart:convert';

import 'package:exbuyapp/mainmenu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../myconfig.dart';
import 'registrationscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  late double screenHeight, screenWidth, cardwidth;
  var pathAsset = "assets/images/login.jpg";

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardwidth = screenWidth;
    } else {
      cardwidth = screenWidth;
    }
    return Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Center(
            child: SingleChildScrollView(
          child: SizedBox(
              width: cardwidth,
              child: Column(children: [
                SizedBox(
                    height: screenHeight / 2.8,
                    width: screenWidth,
                    child: Image.asset(
                      pathAsset,
                      fit: BoxFit.fill,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Card(
                    elevation: 8,
                    margin: const EdgeInsets.all(8),
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(children: [
                            TextFormField(
                                controller: _emailEditingController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) => val!.isEmpty ||
                                        !val.contains("@") ||
                                        !val.contains(".")
                                    ? "enter a valid email"
                                    : null,
                                decoration: const InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.email),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0),
                                    ))),
                            TextFormField(
                                controller: _passEditingController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.password),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0),
                                  ),
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value!;
                                      saveremovepref(value);
                                    });
                                  },
                                ),
                                Flexible(
                                    child: GestureDetector(
                                  onTap: null,
                                  child: const Text('Remember Me',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  minWidth: 115,
                                  height: 50,
                                  elevation: 10,
                                  onPressed: _loginUser,
                                  color: Theme.of(context).colorScheme.primary,
                                  child: const Text('Login'),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ]),
                        ))),
                GestureDetector(
                  onTap: _goLogin,
                  child: const Text(
                    "No account? Register now",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: _goHome,
                  child: const Text(
                    "Go back Home",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ])),
        )));
  }

  void _loginUser() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    String _email = _emailEditingController.text;
    String _pass = _passEditingController.text;
    http.post(Uri.parse("${MyConfig().SERVER}/php/login_user.php"),
        body: {"email": _email, "password": _pass}).then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        User user = User.fromJson(jsonResponse['data']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => MainMenu(
                      user: user,
                    )));
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }

  void _goHome() {
    User user = User(
        id: "0",
        name: "Unregisteres",
        email: "Unregistered",
        phone: "0123456789",
        datereg: "0");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => MainMenu(
                  user: user,
                )));
  }

  void _goLogin() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void saveremovepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Fluttertoast.showToast(
          msg: "Preferences Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        _isChecked = true;
      });
    }
  }
}
