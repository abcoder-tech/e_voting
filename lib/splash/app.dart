

import 'package:e_voting/pages/NEBE/face.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/splash/app_data.dart';
import 'package:flutter/material.dart';


class App extends StatelessWidget {
  const App({
    required this.data,
    super.key,
  });

  final AppData data;

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
        debugShowCheckedModeBanner: false,
            home: loginPage(),
         );
  }
}