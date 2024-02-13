import 'package:flutter/material.dart';
import 'package:fn_641463008/list_view.dart';
import 'package:fn_641463008/mainmenu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListViewScreen(),
      //home: HealthDataPage(),
      routes: {
        '/mainmenu': (context) => MainMenu(),
      },
    );
  }
}
