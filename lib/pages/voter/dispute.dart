import 'dart:async'; // Import Timer
import 'dart:convert';
import 'dart:math';
import 'package:e_voting/pages/NEBE/addschedule.dart';
import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/political_party/political_party_nav_bar.dart';
import 'package:e_voting/pages/voter/voter_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ppoliticaldispute extends StatefulWidget {
  const ppoliticaldispute({super.key});

  @override
  State<ppoliticaldispute> createState() => _ScheduleListState();
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

class _ScheduleListState extends State<ppoliticaldispute> {
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
        fetchdispute();
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

  Future<void> fetchdispute() async {


    final response = await http.get(Uri.parse('${loginPage.apiUrl}dispute/$userId'));





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

  void _showAdddisputeDialog(BuildContext context) {
    //   final TextEditingController _disputeTitleController = TextEditingController();
    final TextEditingController _disputeTextController = TextEditingController();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      title: 'Dispute',
      confirmBtnText: 'Send Dispute',
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
                controller: _disputeTextController,
                decoration: InputDecoration(labelText: ' write Dispute'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      onConfirmBtnTap: () async {
        String result = await adddispute( _disputeTextController.text);
        if (result == 'a') {
          Navigator.pop(context);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Dispute Send  Successfully",
          );
          fetchdispute(); // Refresh the campaign list
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

  Future<String> adddispute(String dispute) async {
    final url = "${loginPage.apiUrl}postdispute"; // Adjust the URL accordingly
    if ( dispute.isEmpty) {
      return 'All fields must be filled out.';
    }


    String generateCustomId() {
      final random = Random();
      const chars = '0123456789';
      return List.generate(3, (index) => chars[random.nextInt(chars.length)]).join();
    }

    String uniqueId ="Dis"+ generateCustomId();
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'ppname': userId,
        'dispute': dispute,

        'disputeid': uniqueId,

      }),
    );

    if (response.statusCode == 201) {
      return 'a'; // Indicate success
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['message'] ?? 'Failed to add Dispute.';
    }
  }

  void _showUpdateDialog(BuildContext context, disputee campa) {
    final TextEditingController _titleController = TextEditingController(text: campa.dispute);
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
        String result = await updatedispute(campa.disputeid, _titleController.text);
        if (result == 'a') {
          Navigator.pop(context);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "You Have Successfully Updated Information",
          );
          fetchdispute(); // Refresh the campaign list
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dispute ${userId}"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: voterNavbarss(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Check if there are no disputes
            if (disputes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 320,left: 100),
                child: Text(
                  'No disputes sent yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            else ...disputes.map((ca) {
              bool isExpanded = expandedScheduleId == ca.disputeid;
              return GestureDetector(
                onTap: () => toggledispute(ca.disputeid),
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
                            'dispute: ${ca.dispute}\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          if (isExpanded) ...[
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showUpdateDialog(context, ca); // Show the update dialog
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Update'),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // Show confirmation dialog
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      text: "Are you sure you want to delete this item?",
                                      confirmBtnText: "Yes",
                                      cancelBtnText: "Cancel",
                                      onConfirmBtnTap: () async {
                                        await _deletedispute(ca.disputeid);
                                        Navigator.pop(context);
                                      },
                                      onCancelBtnTap: () {
                                        Navigator.pop(context);
                                      },
                                    );
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
                                      Icon(Icons.delete_forever),
                                      SizedBox(width: 8),
                                      Text('Delete'),
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
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            _showAdddisputeDialog(context); // Show the add campaign dialog
          },
          tooltip: 'Add Campaign',
          backgroundColor: Colors.green,
          child: Text("New Dispute", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}