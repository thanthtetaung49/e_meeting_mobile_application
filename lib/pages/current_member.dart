import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:e_meeting_mobile_application/class/global_class.dart';

class CurrentMember extends StatefulWidget {
  const CurrentMember({super.key});

  @override
  State<CurrentMember> createState() => _CurrentMemberState();
}

class _CurrentMemberState extends State<CurrentMember> {
  final box = GetStorage();
  String? token = '';
  List currentMember = [];
  late Timer _timer;
  int? numberOfCurrentMember = 0;

  Future<void> getAttendant() async {
    final uri = Uri.parse("http://192.168.1.16:8000/api/member/attendent");
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
    });
    if (response.statusCode == 200) {
      try {
        setState(() {
          currentMember = [];
          currentMember = jsonDecode(response.body);
          numberOfCurrentMember = currentMember.length;
        });
      } catch (e) {
        debugPrint("current member error: $e");
      }
    } else {
      debugPrint("current member HTTP error : ${response.statusCode}");
      setState(() {
        numberOfCurrentMember = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    token = box.read('token');
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getAttendant();
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
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(currentMeetingMember),
                  scrollable: false,
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close"),
                    )
                  ],
                  content: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: currentMember.map((member) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${member['member_name']}"),
                            const Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 10.0,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.people),
        ),
        Positioned(
          right: 4.0,
          child: Container(
            width: 18.0,
            height: 18.0,
            decoration:
                const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: Center(
              child: Text(
                "$numberOfCurrentMember",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
