
import 'package:e_voting/pages/constituencies/constituency_nav_bar.dart';
import 'package:e_voting/pages/political_party/political_party_nav_bar.dart';
import 'package:e_voting/pages/polling_station/polling_station_nav_bar.dart';
import 'package:e_voting/pages/voter/voter_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class voterhomepage extends StatelessWidget {
  const voterhomepage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff2193b0),
        appBar: AppBar(title: Text("Home"),
          backgroundColor:  Color(0xff2193b0),
          //backgroundColor: Colors.blueGrey,
        ),
        drawer: voterNavbarss(),

        body: Scaffold(

        ),


      ),
    );
  }
}
