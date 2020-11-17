import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/Screens/Welcome/welcome_screen.dart';
import 'package:quan_ly_taiducfood/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản Lý Bán Thịt TĐTFood',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
