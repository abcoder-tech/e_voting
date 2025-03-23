import 'dart:async'; // Import Timer
import 'dart:convert';
import 'dart:math';
import 'package:e_voting/pages/NEBE/addschedule.dart';
//import 'package:e_voting/pages/NEBE/election_detail_page.dart';
//import 'package:e_voting/pages/NEBE/nav_bar.dart';
//import 'package:e_voting/pages/NEBE/election_input_page.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/political_party/election_detail.page.dart';
import 'package:e_voting/pages/political_party/political_party_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class elections extends StatefulWidget {
  const elections({super.key});

  @override
  State<elections> createState() => _ScheduleListState();
}

class Election {
  final String electionname;
  final String electionid;
  final List<String> politicalparty; // Assuming it's a list
  final List<String> constituency;    // Assuming it's a list
  final Map<String, dynamic> schedules; // This will hold the nested schedules

  Election({
    required this.electionname,
    required this.electionid,
    required this.politicalparty,
    required this.constituency,
    required this.schedules,
  });

  factory Election.fromJson(Map<String, dynamic> json) {
    return Election(
      electionname: json['electionName'],
      electionid: json['electionId'],
      politicalparty: List<String>.from(json['politicalParties']),
      constituency: List<String>.from(json['constituencies']),
      schedules: json['schedules'], // Assigning the nested schedules
    );
  }
}

class _ScheduleListState extends State<elections> {
  List<Election> elecs = [];
  String? expandedElectionId;// To track the currently expanded schedule
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (userId != null) {
        fetchelection(); // Call fetchcampaign only if userId is not null
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



  Future<void> _deletedispute(String disputeid) async {
    try {
      final response = await http.delete(Uri.parse('${loginPage.apiUrl}dispute/delete/${disputeid}'));
      print('${loginPage.apiUrl}dispute/delete/${disputeid}');
      if (response.statusCode == 200) {
        setState(() {});
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "You have successfully deleted the Dispute.",
        );

        await Future.delayed(Duration(seconds: 1));
        fetchelection();
        Navigator.pop(context);
      } else {
        throw Exception('Failed to delete Dispute');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting Dispute: $e')),
      );
    }
  }

  Future<void> fetchelection() async {


    final response = await http.get(Uri.parse('${loginPage.apiUrl}elections'));






    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        elecs = jsonData.map((json) => Election.fromJson(json)).toList();
      });
    } else {
      print('Failed to load elections');
    }
  }

  void toggleElection(String electionId) {
    setState(() {
      if (expandedElectionId == electionId) {
        expandedElectionId = null; // Collapse if already expanded
      } else {
        expandedElectionId = electionId; // Expand the selected election
      }
    });
  }




  void _showUpdateDialog(BuildContext context, Election campa) {
    final TextEditingController _titleController = TextEditingController(text: campa.electionname);
    // final TextEditingController _campaignnameController = TextEditingController(text: campa.campaigntitle);

    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      title: 'Update Dispute',
      confirmBtnText: 'Update',
      cancelBtnText: 'Cancel',
      widget: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8 - MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Dispute'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      onConfirmBtnTap: () async {
        String result = await updatedispute(campa.electionid, _titleController.text);
        if (result == 'a') {
          Navigator.pop(context);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "You Have Successfully Updated Information",
          );
          fetchelection(); // Refresh the campaign list
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: result,
          );
        }
      },
      onCancelBtnTap: () {
        Navigator.pop(context); // Close the dialog
      },
    );
  }

  Future<String> updatedispute(String disputeid, String dispute) async {
    final url = "${loginPage.apiUrl}updatedispute/$disputeid";
    if (dispute.isEmpty) {
      return 'All fields must be filled out.';
    }

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'disputeid': disputeid,
        //'disputetitle': campaignname,
        'dispute': dispute,
      }),
    );

    if (response.statusCode == 200) {
      return 'a'; // Indicate success
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['message'] ?? 'Failed to update dispute.';
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Elections"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: politicalpartyNavbarss(),
      body: SingleChildScrollView(
        child: Column(
          children: elecs.isNotEmpty
              ? elecs.map((election) {
            bool isExpanded = expandedElectionId == election.electionid;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ElectionDetailPage(
                      electionName: election.electionname,
                      electionId: election.electionid,
                      politicalParties: election.politicalparty,
                      constituencies: election.constituency,
                      schedules: election.schedules,
                    ),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Election Name: ${election.electionname}',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Election ID: ${election.electionid}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Political Parties: ${election.politicalparty.join(", ")}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Constituencies: ${election.constituency.join(", ")}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList()
              : [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top:350.0),
                child: Text(
                  'No elections are set.',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

}