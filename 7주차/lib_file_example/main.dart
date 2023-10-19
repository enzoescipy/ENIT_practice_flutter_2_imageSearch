import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/constants.dart';
import 'package:untitled/tabs.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized(); // 바인딩
  Constants.prefs = await SharedPreferences.getInstance();


  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Tabs(),
    );
  }
}