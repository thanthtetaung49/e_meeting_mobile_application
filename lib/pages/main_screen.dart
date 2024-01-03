import 'package:e_meeting_mobile_application/pages/agenda_data.dart';
import 'package:e_meeting_mobile_application/pages/current_member.dart';
import 'package:e_meeting_mobile_application/pages/menu_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.green,
        child: MenuScreen(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('E-meeting'),
        actions: const [
           CurrentMember()
        ],
      ),
      body: const SafeArea(
        child: Agendas(),
      ),
    )
    );
  }
}
