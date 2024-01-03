import 'dart:async';
import 'dart:convert';

import 'package:e_meeting_mobile_application/class/global_class.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MenuScreen extends StatefulWidget {
   const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final box = GetStorage();
  String? loginUser = '';
  String? token = '';
  late Timer _timer;

  Future<void> logout() async {
    final uri = Uri.parse('http://192.168.1.16:8000/api/member/logout');
    final response = await http.get(uri, headers: {
      "Content-type": 'application/json',
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      try {
        Map result = jsonDecode(response.body);
        if (result['status'] == '1') {
          Navigator.pushNamed(context, "/login");
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    } else {
      debugPrint("HTTP code: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    loginUser = box.read('name');
    token = box.read('token');
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        logout();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    '$loginUser',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 2.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.0),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: Text(
                home,
                style: const TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                logout();
                box.remove('token');
                box.remove('name');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.green,
              ),
              label: const Text(
                "Log out",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
