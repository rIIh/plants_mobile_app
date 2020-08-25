import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:plants/binding/app_binding.dart';
import 'package:plants/color.dart';
import 'widgets/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.main,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Playfair',
        scaffoldBackgroundColor: Colors.white,
      ),
      initialBinding: AppBinding(),
      home: MyHomePage(),
    );
  }
}




