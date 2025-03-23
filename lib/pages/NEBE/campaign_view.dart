import 'dart:async'; // Import Timer
import 'dart:convert';
import 'dart:math';
import 'package:e_voting/pages/NEBE/addschedule.dart';
import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/political_party/political_party_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class nebecampaignList extends StatefulWidget {
  final String name;
  const nebecampaignList({super.key, required this.name});

  @override
  State<nebecampaignList> createState() => _ScheduleListState();
}

class campaignn {
  final String campaigntitle;
  final String ppname;
  final String campaignid;
  final String status;
  final String campaign;

  campaignn({
    required this.ppname,
    required this.campaigntitle,
    required this.campaignid,
    required this.campaign,
    required this.status,
  });

  factory campaignn.fromJson(Map<String, dynamic> json) {
    return campaignn(
      ppname: json['ppname'],
      campaigntitle: json['campaigntitle'],
      campaignid: json['campaignid'],
      status: json['status'],
      campaign: json['campaign'],
    );
  }
}

class _ScheduleListState extends State<nebecampaignList> {
  List<campaignn> campaigns = [];
  String? expandedScheduleId; // To track the currently expanded schedule
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (userId != null) {
        fetchcampaign(widget.name); // Call fetchcampaign only if userId is not null
      } else {
        print('User ID is null. Cannot fetch campaigns.');
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





  Future<void> fetchcampaign(String ppname) async {

print('${ppname}');
    final response = await http.get(Uri.parse('${loginPage.apiUrl}campaignn/$ppname'));






    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        campaigns = jsonData.map((json) => campaignn.fromJson(json)).toList();
      });
    } else {
      print('Failed to load campaign');
    }
  }

  void togglecampaign(String campaignid) {
    setState(() {
      if (expandedScheduleId == campaignid) {
        expandedScheduleId = null; // Collapse if already expanded
      } else {
        expandedScheduleId = campaignid; // Expand the selected schedule
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Campaign "),
        backgroundColor: Color(0xff2193b0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: campaigns.isEmpty
              ? [
            Padding(
              padding: const EdgeInsets.only(top: 320,left: 120),
              child: Text(
                'No campaigns found ',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          ]
              : campaigns.map((ca) {
            bool isExpanded = expandedScheduleId == ca.campaignid;
            return GestureDetector(
              onTap: () => togglecampaign(ca.campaignid),
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
                          'Campaign Title: ${ca.campaigntitle}\n'
                              'Campaign: ${ca.campaign}\n'
                              'Status: ${ca.status}\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        if (isExpanded) ...[
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Show the update dialog
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.block),
                                    SizedBox(width: 8),
                                    Text('Ban'),
                                  ],
                                ),
                              ),
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