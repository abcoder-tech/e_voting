import 'package:e_voting/pages/announcements.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class announcementlist extends StatefulWidget {
  const announcementlist({super.key});

  @override
  State<announcementlist> createState() => _announcementlistState();
}

class _announcementlistState extends State<announcementlist> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color(0xff2193b0),
        appBar: AppBar(title: Text("Announcements"),
          backgroundColor:  Color(0xff2193b0),
          //backgroundColor: Colors.blueGrey,
        ),
        drawer: Navbarss(),

        body:Scaffold(
          body: SingleChildScrollView(
            child: Container(

              child: Padding(
                padding: const EdgeInsets.only(top: 20,),
                child: Column(

                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                        boxShadow: [BoxShadow(
                          color: Colors.grey.shade500,
                          offset: const Offset(4.0, 4.0),
                          blurRadius: 15,
                          spreadRadius: 1.0,
                    
                        )]
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>loginPage()));
                        },
                        child: SingleChildScrollView(
                          child: ReadMoreText("ORGANIZATIONAL "
                              "OVERVIEW"

                              "The National Election Board of Ethiopia (NEBE), re-established by proclamation No. 1133/2011, is the constitutionally mandated body to conduct elections, organize referendum and regulate political parties in Ethiopia. NEBE is working to boost its’ institutional strength with a special focus on enhancement of human resource capacity. Accordingly, NEBE would like to invite applicants for Election Legal Affairs & Case Management Expert position who meet the following requirements"

                                           " Required number:         One"

                                           " Reports to:                    Head, Election Legal Department"

                                        "Duty station:                  NEBE Head Quarter, Addis Ababa"

                                      "  Duration:                        Permanent"

                                      "  Salary:                             As per the organization salary scale (Competitive)"

                                      "    Job Summary"
                              "ORGANIZATIONAL "
                              "OVERVIEW"

                              "The National Election Board of Ethiopia (NEBE), re-established by proclamation No. 1133/2011, is the constitutionally mandated body to conduct elections, organize referendum and regulate political parties in Ethiopia. NEBE is working to boost its’ institutional strength with a special focus on enhancement of human resource capacity. Accordingly, NEBE would like to invite applicants for Election Legal Affairs & Case Management Expert position who meet the following requirements"

                              " Required number:         One"

                              " Reports to:                    Head, Election Legal Department"

                              "Duty station:                  NEBE Head Quarter, Addis Ababa"

                              "  Duration:                        Permanent"

                              "  Salary:                             As per the organization salary scale (Competitive)"

                          "    Job Summary"

                              " Election Legal Affairs & Case Management Expert is responsible for managing legal matters related to electoral processes, overseeing legal compliance, and providing expertise in election-related cases. This role involves legal research, case analysis, policy development, and ensuring adherence to electoral laws and regulations. The Expert plays a critical role in safeguarding the integrity of elections and managing legal cases effectively."

                              "ORGANIZATIONAL "
                              "OVERVIEW"

                              "The National Election Board of Ethiopia (NEBE), re-established by proclamation No. 1133/2011, is the constitutionally mandated body to conduct elections, organize referendum and regulate political parties in Ethiopia. NEBE is working to boost its’ institutional strength with a special focus on enhancement of human resource capacity. Accordingly, NEBE would like to invite applicants for Election Legal Affairs & Case Management Expert position who meet the following requirements"

                              " Required number:         One"

                              " Reports to:                    Head, Election Legal Department"

                              "Duty station:                  NEBE Head Quarter, Addis Ababa"

                              "  Duration:                        Permanent"

                              "  Salary:                             As per the organization salary scale (Competitive)"

                          "    Job Summary"

                              " Election Legal Affairs & Case Management Expert is responsible for managing legal matters related to electoral processes, overseeing legal compliance, and providing expertise in election-related cases. This role involves legal research, case analysis, policy development, and ensuring adherence to electoral laws and regulations. The Expert plays a critical role in safeguarding the integrity of elections and managing legal cases effectively."

                              "ORGANIZATIONAL "
                              "OVERVIEW"

                              "The National Election Board of Ethiopia (NEBE), re-established by proclamation No. 1133/2011, is the constitutionally mandated body to conduct elections, organize referendum and regulate political parties in Ethiopia. NEBE is working to boost its’ institutional strength with a special focus on enhancement of human resource capacity. Accordingly, NEBE would like to invite applicants for Election Legal Affairs & Case Management Expert position who meet the following requirements"

                              " Required number:         One"

                              " Reports to:                    Head, Election Legal Department"

                              "Duty station:                  NEBE Head Quarter, Addis Ababa"

                              "  Duration:                        Permanent"

                              "  Salary:                             As per the organization salary scale (Competitive)"

                          "    Job Summary"

                              " Election Legal Affairs & Case Management Expert is responsible for managing legal matters related to electoral processes, overseeing legal compliance, and providing expertise in election-related cases. This role involves legal research, case analysis, policy development, and ensuring adherence to electoral laws and regulations. The Expert plays a critical role in safeguarding the integrity of elections and managing legal cases effectively."


                              " Election Legal Affairs & Case Management Expert is responsible for managing legal matters related to electoral processes, overseeing legal compliance, and providing expertise in election-related cases. This role involves legal research, case analysis, policy development, and ensuring adherence to electoral laws and regulations. The Expert plays a critical role in safeguarding the integrity of elections and managing legal cases effectively."
                                              ,
                            style: TextStyle(
                              fontSize: 16,

                            ),
                            moreStyle: TextStyle(
                              color: Colors.blue,
                              fontSize: 18
                            ),
                             lessStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18
                              )




                             ),
                        ),
                      ),
                    
                    
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                          boxShadow: [BoxShadow(
                            color: Colors.grey.shade500,
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 15,
                            spreadRadius: 1.0,

                          )]
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                          boxShadow: [BoxShadow(
                            color: Colors.grey.shade500,
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 15,
                            spreadRadius: 1.0,

                          )]
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                          boxShadow: [BoxShadow(
                            color: Colors.grey.shade500,
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 15,
                            spreadRadius: 1.0,

                          )]
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                          boxShadow: [BoxShadow(
                            color: Colors.grey.shade500,
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 15,
                            spreadRadius: 1.0,

                          )]
                      ),
                    )
                  ],
                ),
              ),

            ),

          ),

        ),
        floatingActionButton: Container(
          height: 50,
          width: 100,

          child: FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>announcment()));
            },
            tooltip: 'Increment',
            backgroundColor: Colors.green,
            child: Text("Add Post",
            style: TextStyle(
fontSize: 18
            ),),
          ),
        )


    );
  }
}
