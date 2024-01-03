import 'dart:convert';

import 'package:e_meeting_mobile_application/class/global_class.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final box = GetStorage();
  bool validationStatus = false;
  bool loginResponseStatus = false;
  String? loginIdErrorText;
  String? passwordErrorText;

  Future<void> login() async {
    final uri = Uri.parse("http://192.168.1.16:8000/api/member/login");
    final response = await http.post(uri, body: {
      'loginID': _loginIdController.text,
      'password': _passwordController.text,
    });
    try {
      Map result = jsonDecode(response.body);
      if (result.containsKey('token')) {
        box.write('token', result['token']);
        box.write('name', result['memberName']);
        Navigator.pushNamed(context, '/home');
        validationStatus = false;
        loginResponseStatus = false;
      } else {
        setState(() {
          loginResponseStatus = true;
          print(loginResponseStatus);
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                Container(
                  width: 500.0,
                  height: 300.0,
                  margin: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      Image.asset('assets/logo.jpg', width: 50.0, height: 50.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          governmentTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(title),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          tinderTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          tinderNo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 500.0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(75.0),
                        topRight: Radius.circular(75.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (loginResponseStatus) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.red[300],
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                      if (validationStatus == false) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          child: TextField(
                            controller: _loginIdController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Login ID",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password",
                            ),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          child: TextField(
                            controller: _loginIdController,
                            autofocus: true,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: "Login ID",
                                errorText: loginIdErrorText),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Password",
                              errorText: passwordErrorText,
                            ),
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  )),
                              onPressed: () {
                                if (_loginIdController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty) {
                                  login();
                                } else {
                                  setState(() {
                                    validationStatus = true;
                                    loginIdErrorText =
                                        "Need to fill login ID field";
                                    passwordErrorText =
                                        "Need to fill password field";
                                  });
                                  debugPrint(
                                      "Validation Status: $validationStatus");
                                }
                              },
                              child: const Text(
                                "Submit",
                                style: TextStyle(fontSize: 15.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
