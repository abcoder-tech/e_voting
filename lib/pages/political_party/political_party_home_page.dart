
import 'package:e_voting/pages/constituencies/constituency_nav_bar.dart';
import 'package:e_voting/pages/political_party/political_party_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class politicalpartyhomepage extends StatelessWidget {

  const politicalpartyhomepage({super.key,  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff2193b0),
      appBar: AppBar(title: Text("Home "),
        backgroundColor:  Color(0xff2193b0),
        //backgroundColor: Colors.blueGrey,
      ),
      drawer: politicalpartyNavbarss(),

      body: Scaffold(

      ),


    );
  }
}
