import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mytextfiled extends StatelessWidget {
  final controller;
  final String hinttext;
  final String labeel;
  final bool obscuretext;
  final IconButton icoon;
  final String? validity;
  const mytextfiled({super.key,
    this.controller,
    required this.hinttext,
    required this.obscuretext, 
    required this.labeel,
    required this.validity,
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
          errorStyle: TextStyle(color: Colors.red),
          errorText: validity,
          label: Text(labeel,style: 
            TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5F4490),
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
