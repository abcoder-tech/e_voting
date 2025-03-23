import 'dart:async'; // Import Timer
import 'dart:convert';
import 'dart:math';
import 'package:e_voting/pages/NEBE/addschedule.dart';
import 'package:e_voting/pages/NEBE/nav_bar.dart';

import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/political_party/political_party_nav_bar.dart';
import 'package:e_voting/pages/polling_station/polling_station_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class viewdispute extends StatefulWidget {
  const viewdispute({super.key});

  @override
  State<viewdispute> createState() => _ScheduleListState();
}

class disputee {
  final String role;
  final String disputeid;
  final String status;
  final String dispute;

  disputee({required this.role, required this.disputeid, required this.status, required this.dispute,

  });

  factory disputee.fromJson(Map<String, dynamic> json) {
    return disputee(
      role: json['role'],
      disputeid: json['disputeid'],
      dispute: json['dispute'],
      status: json['status'],

    );
  }
}

class _ScheduleListState extends State<viewdispute> {
  List<disputee> disputes = [];
  String? expandedScheduleId; // To track the currently expanded schedule
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (userId != null) {
        fetchdispute(); // Call fetchcampaign only if userId is not null
      } else {
        print('User ID is null. Cannot fetch disputes.');
      }
    });
  }



  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
    print('Loaded User ID: $userId'); // For debugging
  }





  Future<void> fetchdispute() async {


    final response = await http.get(Uri.parse('${loginPage.apiUrl}dispute'));





    print("${loginPage.apiUrl}dispute/${userId}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        disputes = jsonData.map((json) => disputee.fromJson(json)).toList();
      });
    } else {
      print('Failed to load dispute');
    }
  }

  void toggledispute(String disputeid) {
    setState(() {
      if (expandedScheduleId == disputeid) {
        expandedScheduleId = null; // Collapse if already expanded
      } else {
        expandedScheduleId = disputeid; // Expand the selected schedule
      }
    });
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disputes "),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: pollingstationNavbarss(),
      body: SingleChildScrollView(
        child: Column(
          children: disputes.map((ca) {
            bool isExpanded = expandedScheduleId == ca.disputeid;
            return GestureDetector(
            //  onTap: () => toggledispute(ca.disputeid),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // 'Campaign Title: ${ca.campaigntitle}\n'
                          'dispute: ${ca.dispute}\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        if (isExpanded) ...[
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),

    );
  }
}