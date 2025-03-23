import 'package:e_voting/splash/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const AppLoader());
}

//class MyApp extends StatelessWidget {
 // const MyApp({super.key});

  // This widget is the root of your application.
  //@override
  //Widget build(BuildContext context) {
 //   return MaterialApp(
  //    debugShowCheckedModeBanner: false,
  //    home: loginPage(),
  //  );
//  }
//}