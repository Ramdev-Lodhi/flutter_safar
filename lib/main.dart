import 'package:flutter/material.dart';
import 'package:safar/view/splash.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Safar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff212529)),
        useMaterial3: true,
      ),
      home: SplashView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
