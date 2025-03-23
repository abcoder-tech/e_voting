import 'dart:convert';

import 'package:e_voting/components/mybotton.dart';
import 'package:e_voting/components/mytextfiled.dart';
import 'package:e_voting/pages/NEBE/home_page.dart';
import 'package:e_voting/pages/constituencies/constituency_home_page.dart';
import 'package:e_voting/pages/constituencies/news.dart';
import 'package:e_voting/pages/political_party/news.dart';
import 'package:e_voting/pages/political_party/political_party_home_page.dart';
import 'package:e_voting/pages/polling_station/news.dart';
import 'package:e_voting/pages/polling_station/polling_station_home_page.dart';
import 'package:e_voting/pages/voter/news.dart';
import 'package:e_voting/pages/voter/voter_home.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class loginPage extends StatefulWidget {
  static const String apiUrl= 'http://192.168.64.27:5000/';

  const loginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<loginPage> with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isnotvalidu = false;
  bool _isnotvalidp = false;
  bool _isPasswordObscured = true;
  static const String apiUrl = 'http://192.168.64.27:5000/';
  bool _isLoading = false;

  // Animation variables
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation

    _animation = Tween<double>(begin: 20.0, end: 30.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
    super.dispose();
  }


  void signUserIn() async{
    if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
     // Navigator.push(
      //  context,mongodb:
      //  MaterialPageRoute(builder: (context) => homepage()),
    //  );
      setState(() => _isLoading = true);

      var regBody = {
        "ID": usernameController.text,
        "password": passwordController.text
      };
      try {
        var response = await http.post(
          Uri.parse(apiUrl+"login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          String role =jsonResponse['message'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', usernameController.text);


          QuickAlert.show(
              context:context,
              type:QuickAlertType.success,
              text:"you succesfully login",
          );
          await Future.delayed(Duration(seconds: 2));
          if(role=="admin"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
          }else if(role=="Political Party"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => userAnnouncementList()));
          }else if(role=="Constituency"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => conAnnouncementList()));
        }else if(role=="Polling Station"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => coonAnnouncementList()));
          }else if(role=="Voter"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => uuserAnnouncementList()));
          }

        } else {
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: jsonResponse['message'] ?? 'Something went wrong',
          );
          await Future.delayed(Duration(seconds: 1));
          // Display error message based on response
        }
       // Text(jsonResponse['message'] ?? 'Something went wrong')
      } catch (error) {
        QuickAlert.show(
          context:context,
          type:QuickAlertType.error,
          text:"$error",
        );
        await Future.delayed(Duration(seconds: 1));

      } finally {
        setState(() => _isLoading = false);
      }
    } else {
    usernameController.text.isEmpty?setState(() {
      _isnotvalidu=true;
    }):setState(() {
      _isnotvalidu=false;
    });
    passwordController.text.isEmpty?setState(() {
      _isnotvalidp=true;
    }):setState(() {
      _isnotvalidp=false;
    });

      }

      // Handle empty fields
    }



  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
          // Prevent back navigation
          return false;
        },
    child:

    Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(

              color: Color(0xFF5F4490)
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xff2193b0),
                        ),
                        height: 70,
                        width: 90,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/images/loginew.jpg'),
                              //fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF5F4490),
                        ),
                        height: screenHeight * 0.1,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "NATIONAL ELECTION BOARD OF ELECTION\n"
                                "              የኢትዮጵያ ብሔራዊ ምርጫ ቦርድ"
                            ,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          ),
                        ),
                      ),

                     //
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Text(

                          "Trusted For Your Vote"
                              ,
                      style: TextStyle(
                        fontSize: _animation.value,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 220),
            child: Container(
              margin: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Your existing text fields...
                      mytextfiled(
                        hinttext: "Enter Username",
                        obscuretext: false,
                        controller: usernameController,
                        labeel: 'User Id',
                        validity: _isnotvalidu ? "Please Enter Username" : null,
                        icoon: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {},
                        ),
                      ),
                      mytextfiled(
                        obscuretext: _isPasswordObscured,
                        hinttext: "Enter Password",
                        controller: passwordController,
                        labeel: 'Password',
                        validity: _isnotvalidp ? "Please Enter Password" : null,
                        icoon: IconButton(
                          icon: Icon(
                            _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscured = !_isPasswordObscured; // Toggle password visibility
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xff281537),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                      mybotton(
                        onTap: () {
                          signUserIn(); // Call the sign-in method
                        },
                        butttontext: 'Sign In',
                      ),
                      const SizedBox(height: 40), // Adjust spacing


                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}