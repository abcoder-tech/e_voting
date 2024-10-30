import 'package:e_voting/components/mybotton.dart';
import 'package:e_voting/pages/home_page.dart';
import 'package:e_voting/pages/nav_bar.dart';
import 'package:e_voting/pages/nebe_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class announcment extends StatefulWidget {
  const announcment({super.key});

  @override
  State<announcment> createState() => _announcmentState();
}

class _announcmentState extends State<announcment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2193b0),
      appBar: AppBar(title: Text("Announcements"),
        backgroundColor:  Color(0xff2193b0),
        //backgroundColor: Colors.blueGrey,
      ),
      drawer: Navbarss(),

      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                          isDense: true,
                        hintText: "Write a Announcement here",

                      ),
                      textAlignVertical: TextAlignVertical.top,


                  ),

                ),


              ),
              const SizedBox(height: 20,),
              mybotton(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
                }, butttontext: 'Post Announcement',
              ),
            ],
          ),
        ),
      ),


    );
  }
}
