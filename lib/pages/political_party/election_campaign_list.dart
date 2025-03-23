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

class campaignList extends StatefulWidget {
  const campaignList({super.key});

  @override
  State<campaignList> createState() => _ScheduleListState();
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

class _ScheduleListState extends State<campaignList> {
  List<campaignn> campaigns = [];
  String? expandedScheduleId; // To track the currently expanded schedule
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (userId != null) {
        fetchcampaign(); // Call fetchcampaign only if userId is not null
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



  Future<void> _deletecampaign(String campaignid) async {
    try {
      final response = await http.delete(Uri.parse('${loginPage.apiUrl}campaign/delete/${campaignid}'));
print('${loginPage.apiUrl}campaign/delete/${campaignid}');
      if (response.statusCode == 200) {
        setState(() {});
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "You have successfully deleted the campaign.",
        );

        await Future.delayed(Duration(seconds: 1));
        fetchcampaign();
        Navigator.pop(context);
      } else {
        throw Exception('Failed to delete campaign');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting campaign: $e')),
      );
    }
  }

  Future<void> fetchcampaign() async {


final response = await http.get(Uri.parse('${loginPage.apiUrl}campaign/$userId'));





print("${loginPage.apiUrl}campaign/${userId}");
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

  void _showAddCampaignDialog(BuildContext context) {
    final TextEditingController _campaignTitleController = TextEditingController();
    final TextEditingController _campaignTextController = TextEditingController();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      title: 'Add Campaign',
      confirmBtnText: 'Post',
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
                controller: _campaignTitleController,
                decoration: InputDecoration(labelText: 'Campaign Title'),
              ),
              TextField(
                controller: _campaignTextController,
                decoration: InputDecoration(labelText: 'Campaign'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      onConfirmBtnTap: () async {
        String result = await addCampaign(_campaignTitleController.text, _campaignTextController.text);
        if (result == 'a') {
          Navigator.pop(context);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Campaign Added Successfully",
          );
          fetchcampaign(); // Refresh the campaign list
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

  Future<String> addCampaign(String campaignname, String campaign) async {
    final url = "${loginPage.apiUrl}postcampaign"; // Adjust the URL accordingly
    if (campaignname.isEmpty || campaign.isEmpty) {
      return 'All fields must be filled out.';
    }


    String generateCustomId() {
      final random = Random();
      const chars = '0123456789';
      return List.generate(3, (index) => chars[random.nextInt(chars.length)]).join();
    }

    String uniqueId ="cam"+ generateCustomId();
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'ppname': userId,
        'campaigntitle': campaignname,
        'campaign': campaign,
        'campaignid': uniqueId,

      }),
    );

    if (response.statusCode == 201) {
      return 'a'; // Indicate success
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['message'] ?? 'Failed to add campaign.';
    }
  }

  void _showUpdateDialog(BuildContext context, campaignn campa) {
    final TextEditingController _titleController = TextEditingController(text: campa.campaign);
    final TextEditingController _campaignnameController = TextEditingController(text: campa.campaigntitle);

    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      title: 'Update Campaign',
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
                controller: _campaignnameController,
                decoration: InputDecoration(labelText: 'Campaign Title'),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Campaign'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      onConfirmBtnTap: () async {
        String result = await updatecampaign(campa.campaignid, _campaignnameController.text, _titleController.text);
        if (result == 'a') {
          Navigator.pop(context);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "You Have Successfully Updated Information",
          );
          fetchcampaign(); // Refresh the campaign list
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

  Future<String> updatecampaign(String campaignid, String campaignname, String campaign) async {
    final url = "${loginPage.apiUrl}updatecampaign/$campaignid";
    if (campaign.isEmpty) {
      return 'All fields must be filled out.';
    }

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'campaignid': campaignid,
        'campaigntitle': campaignname,
        'campaign': campaign,
      }),
    );

    if (response.statusCode == 200) {
      return 'a'; // Indicate success
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['message'] ?? 'Failed to update campaign.';
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Campaign ${userId}"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: politicalpartyNavbarss(),
      body: SingleChildScrollView(
        child: Column(
          children: campaigns.isNotEmpty
              ? campaigns.map((ca) {
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
                              'Campaign: ${ca.campaign}\n',
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
                                      await _deletecampaign(ca.campaignid);
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
          }).toList()
              : [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 320),
                child: Text(
                  'No election campaigns posted yet.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            _showAddCampaignDialog(context); // Show the add campaign dialog
          },
          tooltip: 'Add Campaign',
          backgroundColor: Colors.green,
          child: Text("Add Campaign", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}