import 'dart:convert';

import 'package:e_voting/components/mybotton.dart';
import 'package:e_voting/components/mytextfiled.dart';
import 'package:e_voting/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class loginPage extends StatefulWidget {
  static const String apiUrl= 'http://192.168.182.27:5000/';

  const loginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<loginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isnotvalidu=false;
  bool _isnotvalidp=false;
  bool _isPasswordObscured = true;
  static const String apiUrl = 'http://192.168.182.27:5000/';
  bool _isLoading = false;

  void signUserIn() async{
    if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
     // Navigator.push(
      //  context,mongodb:
      //  MaterialPageRoute(builder: (context) => homepage()),
    //  );
      setState(() => _isLoading = true);

      var regBody = {
        "email": usernameController.text,
        "password": passwordController.text
      };
      try {
        var response = await http.post(
          Uri.parse(apiUrl+"register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          SnackBar(content: Container(
            padding:const EdgeInsets.all(8),
            height: 80,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle,
                  color: Colors.white,
                  size: 40,),
                SizedBox(width: 20,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Success",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                    Text(
                      "You Are Sucessfully Registered",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,

                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ))
              ],
            ),
          ),
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
          );

          Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
        } else {
          // Display error message based on response
          final snackBar=  SnackBar(content: Container(
            padding:const EdgeInsets.all(8),
            height: 80,

              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(10)),

              ),
              child: Row(
                children: [
                  const Icon(Icons.error,
                  color: Colors.white,
                      size: 40,),
                  SizedBox(width: 20,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         "Eroor",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      Text(
                          jsonResponse['message'] ?? 'Something went wrong',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,

                        ),
                        maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ))
                ],
              ),
          ),backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
           duration: Duration(seconds: 3),
           padding: EdgeInsets.all(16.0),
          );
         ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
       // Text(jsonResponse['message'] ?? 'Something went wrong')
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erroor: $error')));
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff2193b0),
                  Color(0xff6dd5ed)
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 60, left: 22),
              child: Text(
                "Hello\nSign in!",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 200),

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

                      mytextfiled(

                        hinttext: "Enter Username",
                        obscuretext: false,
                        controller: usernameController,
                        labeel: 'User Id',
                       validity:  _isnotvalidu ? "Please Enter Username" : null,
                        icoon: IconButton(
                          icon: Icon(
                            Icons.check ,
                          ),
                          onPressed: () {
                          },
                        ),
                      ),
                      mytextfiled(
                        obscuretext:  _isPasswordObscured,
                        hinttext: "Enter Password",
                        controller: passwordController,
                        labeel: 'Password',
                          validity:  _isnotvalidp ? "Please Enter Password" : null,
                        icoon:  IconButton(
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
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}