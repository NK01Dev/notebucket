import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_bucket/src/res/strings.dart';
import 'package:note_bucket/src/views/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
title: AppStrings.AppName,
      color: Colors.white,
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

useMaterial3: true

      ),
      home: HomeView(),
    );
  }
}
