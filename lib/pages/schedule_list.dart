import 'package:e_voting/pages/addpoliticalparty.dart';
import 'package:e_voting/pages/addschedule.dart';
import 'package:e_voting/pages/announcment_view.dart';
import 'package:e_voting/pages/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class schedulelist extends StatefulWidget {
  const schedulelist({super.key});

  @override
  State<schedulelist> createState() => _schedulelistState();
}

class _schedulelistState extends State<schedulelist> {

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Schedule"),
          backgroundColor: Color(0xff2193b0),
        ),
        drawer: Navbarss(),
        body:SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewannouncement()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 20,right: 10),
                  child: Container(
                    height: 140,
                   width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10,top: 10 ,left: 20,),
                      child: Text(
                        'Schedule Title: \nStarted Date:  \n Ended Date: \n Status : \nDescription: ', // Display dynamic data
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewannouncement()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 20,right: 10),
                  child: Container(
                    height: 140,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10,top: 10 ,left: 20,),
                      child: Text(
                        'Schedule Title: \nStarted Date:  \n Ended Date: \n Status : \nDescription: ', // Display dynamic data
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewannouncement()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 20,right: 10),
                  child: Container(
                    height: 140,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10,top: 10 ,left: 20,),
                      child: Text(
                        'Schedule Title: \nStarted Date:  \n Ended Date: \n Status : \nDescription: ', // Display dynamic data
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewannouncement()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 20,right: 10),
                  child: Container(
                    height: 140,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10,top: 10 ,left: 20,),
                      child: Text(
                        'Schedule Title: \nStarted Date:  \n Ended Date: \n Status : \nDescription: ', // Display dynamic data
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewannouncement()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 20,right: 10,bottom: 20),
                  child: Container(
                    height: 140,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10,top: 10 ,left: 20,),
                      child: Text(
                        'Schedule Title: \nStarted Date:  \n Ended Date: \n Status : \nDescription: ', // Display dynamic data
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 20,right: 10),
                  child: Container(
                    height: 140,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10,top: 10 ,left: 20,),
                      child: Text(
                        'Schedule Title: \nStarted Date:  \n Ended Date: \n Status : \nDescription: ', // Display dynamic data
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                ),
              )
            ],
          ),
        ),
      floatingActionButton: Container(
      height: 50,
      width: 100,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => addschedule()));
        },
        tooltip: 'Add Schedule',
        backgroundColor: Colors.green,
        child: Text("Add Schedule", style: TextStyle(fontSize: 18)),
      ),
    ),
    );
  }
}
