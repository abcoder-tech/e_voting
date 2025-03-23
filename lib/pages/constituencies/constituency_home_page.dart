
import 'package:e_voting/pages/constituencies/constituency_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class constituencyhomepage extends StatelessWidget {
  const constituencyhomepage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff2193b0),
      appBar: AppBar(title: Text("Home"),
        backgroundColor:  Color(0xff2193b0),
        //backgroundColor: Colors.blueGrey,
      ),
      drawer: constituencyNavbarss(),

      body: Scaffold(

    ),


    );
  }
}
