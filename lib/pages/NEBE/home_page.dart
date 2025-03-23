
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'nebe_home.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff2193b0),
        appBar: AppBar(title: Text("Home"),
        backgroundColor:  Color(0xff2193b0),
        //backgroundColor: Colors.blueGrey,
        ),
        drawer: Navbarss(),

        body: NebeHome(),


    );
  }
}
