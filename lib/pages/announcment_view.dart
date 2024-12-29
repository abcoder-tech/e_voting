import 'package:e_voting/pages/announcement_list.dart';
import 'package:e_voting/pages/announcements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class viewannouncement extends StatefulWidget {
  const viewannouncement({super.key});

  @override
  State<viewannouncement> createState() => _ViewAnnouncementState();
}

class _ViewAnnouncementState extends State<viewannouncement> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff2193b0),
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Container(
          height: screenHeight,
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(80),
              topRight: Radius.circular(80),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => announcementlist()));
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 40,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15),
                        child: Text(
                          "Posted Date : 10/30/2024 12:01 pm",
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15),
                        child: Text(
                          "Last Updated at : 10/30/2024 12:20 pm",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row for first two images
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "lib/images/voter.jpg", // First image path
                                  height: 150, // Adjust heig ht as needed
                                  fit: BoxFit.cover, // Adjust fit as needed
                                ),
                              ),
                              SizedBox(width: 10), // Space between images
                              Expanded(
                                child: Image.asset(
                                  "lib/images/voter.jpg", // Second image path
                                  height: 150, // Adjust height as needed
                                  fit: BoxFit.cover, // Adjust fit as needed
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Space below the first row of images
                          // Row for third image
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "lib/images/voter.jpg", // Third image path
                                  height: 150, // Adjust height as needed
                                  fit: BoxFit.cover, // Adjust fit as needed
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Space below the third image
                          ReadMoreText(
                            "ORGANIZATIONAL OVERVIEW\n"
                                "The National Election Board of Ethiopia (NEBE), re-established by proclamation No. 1133/2011, is the constitutionally mandated body to conduct elections, organize referendum and regulate political parties in Ethiopia. NEBE is working to boost its’ institutional strength with a special focus on enhancement of human resource capacity. Accordingly, NEBE would like to invite applicants for Election Legal Affairs & Case Management Expert position who meet the following requirements"
                                " \nRequired number: One\n"
                                " Reports to: Head, Election Legal Department"
                                "\nDuty station: NEBE Head Quarter, Addis Ababa"
                                " \n Duration: Permanent"
                                " \nSalary: As per the organization salary scale (Competitive)"
                                " \n Job Summary"
                                " Election Legal Affairs & Case Management Expert is responsible for managing legal matters related to electoral processes, overseeing legal compliance, and providing expertise in election-related cases. This role involves legal research, case analysis, policy development, and ensuring adherence to electoral laws and regulations. The Expert plays a critical role in safeguarding the integrity of elections and managing legal cases effectively.",
                            style: TextStyle(fontSize: 16),
                            moreStyle: TextStyle(color: Colors.blue, fontSize: 18),
                            lessStyle: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 50,
            width: 100,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => announcments()));
              },
              tooltip: 'Update',
              backgroundColor: Colors.blue,
              child: Text(
                "Update",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 100,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => announcments()));
              },
              tooltip: 'Delete',
              backgroundColor: Colors.red,
              child: Text(
                "Delete",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}