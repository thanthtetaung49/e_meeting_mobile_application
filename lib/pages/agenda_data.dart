import 'dart:async';
import 'dart:convert';

import 'package:e_meeting_mobile_application/pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:e_meeting_mobile_application/pages/show_attachment_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:e_meeting_mobile_application/class/global_class.dart';

class Agendas extends StatefulWidget {
  const Agendas({super.key});

  @override
  State<Agendas> createState() => _AgendasState();
}

class _AgendasState extends State<Agendas> {
  final box = GetStorage();
  String? token = '';
  Map<String, dynamic> currentMeeting = {};
  List agendas = [];
  late Timer _timer;
  bool isLoading = true;
  bool currentMeetingStatus = true;

  Future<void> getAgendas() async {
    final uri = Uri.parse('http://192.168.1.16:8000/api/member/home');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json'
    });
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> result = jsonDecode(response.body);
        setState(() {
          if (result.containsKey("agendas")) {
            currentMeeting = result;
            agendas = [];
            agendas = result['agendas'];
            isLoading = false;
            currentMeetingStatus = true;
          } else {
            agendas = [];
            currentMeeting = result;
            currentMeetingStatus = false;
            isLoading = false;
          }
        });
      } catch (e) {
        debugPrint("Agendas error: $e");
      }
    } else {
      debugPrint("Agenda HTTP error: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    token = box.read('token');
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getAgendas();
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
    return isLoading ?
      const Loading()
    : 
    ListView(children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              if (currentMeetingStatus == false) ...[
                Text(
                  currentMeetingMessage,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const SizedBox(
                  height: 5.0,
                ),
              ] else ...[
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text("$meetingNo (${currentMeeting['meetingNo']})"),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${currentMeeting['meetingType']}",
                  style: const TextStyle(color: Colors.blue),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text("${currentMeeting['meetingDate']}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text("${currentMeeting['meetingTime']}"),
                    )
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: agendas.map((agenda) {
            return Semantics(
              container: true,
              child: Card(
                color: agenda['ActiveStatus'] == '1'
                    ? Colors.green[400]
                    : Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (agenda['attachments'] == null) ...[
                        Text(
                          "${agenda['agenda_name']}",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: agenda['ActiveStatus'] == '1'
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Text(
                          "${agenda['member_name']} (${agenda['rank_name']} - ${agenda['department_name']})",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: agenda['ActiveStatus'] == '1'
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ] else ...[
                        Text(
                          "${agenda['agenda_name']}",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: agenda['ActiveStatus'] == '1'
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Text(
                          "${agenda['member_name']} (${agenda['rank_name']} - ${agenda['department_name']})",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: agenda['ActiveStatus'] == '1'
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ElevatedButton(
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
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PdfScreen(
                                          attachments: agenda['attachments']),
                                    ),
                                  );
                                },
                                child: Text(
                                  seeMore,
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                              ),
                            )
                          ],
                        )
                      ], // Text("${agenda['attachments']}")
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      )
    ]);
  }
}
