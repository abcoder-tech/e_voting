import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mytextfiled extends StatelessWidget {
  final controller;
  final String hinttext;
  final String labeel;
  final bool obscuretext;
  final Icon icoon;
  const mytextfiled({super.key,
    this.controller,
    required this.hinttext,
    required this.obscuretext, 
    required this.labeel,
    required this.icoon});

  @override
  Widget build(BuildContext context) {
    return    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30  ),
      child: TextField(
        controller: controller,
        obscureText: obscuretext,
        decoration: InputDecoration(
          suffixIcon: icoon,
          label: Text(labeel,style: 
            TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff2193b0),
fontSize: 20
            ),
          ),
          hintText: hinttext,
          hintStyle: TextStyle(color:(Colors.grey)),
          //  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white),
            ),



        ),


    );
  }
}
