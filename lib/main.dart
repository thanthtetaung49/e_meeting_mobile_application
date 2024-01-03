import 'package:e_meeting_mobile_application/pages/login_screen.dart';
import 'package:e_meeting_mobile_application/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: const DrawerScreen(),
      initialRoute: '/login',
      routes: {
        '/login' : (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
