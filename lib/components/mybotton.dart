import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mybotton extends StatelessWidget {
  final String butttontext;
  const mybotton({super.key, this.onTap, required this.butttontext });
final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xff2193b0),
                Color(0xff6dd5ed),
              ] ),
          borderRadius: BorderRadius.circular(8),

        ),
        child: Center(
          child: Text(
            butttontext,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
        ) ,
      ),
    );

  }
}
