import 'dart:convert';

import 'package:e_voting/models/Constituency.dart';
import 'package:e_voting/pages/NEBE/constituencies_list.dart';
import 'package:e_voting/pages/NEBE/political_party_list.dart';
import 'package:e_voting/pages/NEBE/update_political_party.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_voting/services/api_service.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;

class viewconstituency extends StatefulWidget {
  final String ID;
  final String email;
  final String name;
  final String description;
  final String region;
  final int no_polling;

  const viewconstituency({super.key, required this.email, required this.name, required this.description, required this.region, required this.ID, required this.no_polling,});

  @override
  State<viewconstituency> createState() => _viewpartyState();
}

class _viewpartyState extends State<viewconstituency> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  void initState() {
    super.initState();
    nameController.text = widget.name;
    emailController.text = widget.email;
    _descriptionController.text = widget.description;// Set the initial value here
  }


  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    _descriptionController.dispose(); // Dispose the controller
    super.dispose();
  }


//final ApiService _apiService = ApiService(); // Create an instance of your API service
  final List<String> regions = [
    'Addis Ababa',
    'Dire Dawa',
    'Tigray',
    'Afar',
    'Amhara',
    'Oromia',
    'Somalia',
    'SNNP',
    'Harar',
  ];
  Future<void> _deleteConstituency() async {


    try {
      bool success = await deleteConstituency(widget.email);
      if (success) {
        // Notify the user and navigate back
        QuickAlert.show(
          context:context,
          type:QuickAlertType.success,
          text:"you succesfully delete Constituency",
        );

        await Future.delayed(Duration(seconds: 1));
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConstituencyList())); // Navigate back to the previous screen
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting Constituency: $e')),
      );
    }
  }

  Future<String> updateConstituency(String ID,String name, String email, String region, String description) async {
    final url = "${loginPage.apiUrl}updateConstituency/$ID";
    print("Updating schedule at URL: $url");




    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'region': region,
        'description': description,
      }),
    );

// Log the status code
    print("Response status code: ${response.statusCode}");

// Read response body and decode it
    final responseBody = response.body;
    print("Response body: $responseBody");
// Log the response body

    if (response.statusCode == 200) {
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      final Map<String, dynamic> responseData = json.decode(responseBody);
      return  'a';
    } else {
      final Map<String, dynamic> responseData = json.decode(responseBody);
      return responseData['message'] ?? 'Failed to update schedule.';
    }
  }

  void _showupdateConstituencyDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



    String selectedRegion = regions[0];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  color: Color(0xFF2A6F88),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 88,
                padding: EdgeInsets.all(18),
                child: Center(
                  child: Text(
                    "Update Constituency",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(labelText: 'Constituency Name'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a constituency name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller:  _descriptionController,
                              decoration: InputDecoration(labelText: 'Description'),

                            ),

                            Row(
                              children: [
                                Text("Region: ", style: TextStyle(fontSize: 18)),
                                SizedBox(width: 10),
                                DropdownButton<String>(
                                  value: selectedRegion,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedRegion = newValue!;
                                    });
                                  },
                                  items: regions.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: ()  async {
                String result = await updateConstituency(widget.ID,nameController.text, emailController.text, widget.region, _descriptionController.text);
                if (result == 'a') {
                  Navigator.pop(context);
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: "You Are Successfully Updated Information",
                  );
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConstituencyList())); // Navigate back to the previous screen

                  // Refresh the schedule list
                  // Close the dialog
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: result,
                  );
                }
              },
              child: Text('Update', style: TextStyle(color: Color(0xFF2A6F88), fontSize: 19, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context ) {
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ConstituencyList()));
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
                        padding: const EdgeInsets.only(left:60, top: 10),
                        child: Center(
                          child: Text(
                            "${widget.name} Constituency",
                            style: TextStyle(color: Colors.green, fontSize: 30,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),


                    ],
                  )
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),// Row for first two images
                            Text(
                              'Name:  ${widget.name}\n'
                                  'Email:  ${widget.email}\n'
                                  'Region:  ${widget.region}\n'
                                  'Number of Polling Stations: ${widget.no_polling} \n '
                                  'Number of candidates:  \n ''Number of voter:  \n'
                                  ' Description:  '
                                  '${widget.description}'
                              ,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                            Divider()
                          ]),
                    ),
                  ),
                ),
              ) ],
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
                _showupdateConstituencyDialog(context);
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
              onPressed: () async {
                // Show confirmation dialog
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  text: "Are you sure you want to delete ${widget.name} Constituency?",
                  confirmBtnText: "Yes",
                  cancelBtnText: "Cancel",
                  onConfirmBtnTap: () async {
                    // Call your delete function here
                    await _deleteConstituency(); // Replace with your actual delete function

                    // Show success message after deletion
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "Constituency deleted successfully.",
                    );

                    // Optional: Wait for a moment before navigating back or performing another action
                    await Future.delayed(Duration(seconds: 1));

                    // Navigate back or perform any other action
                    Navigator.pop(context); // Go back to the previous page
                  },
                  onCancelBtnTap: () {
                    // Simply dismiss the dialog
                    Navigator.pop(context);
                  },
                );
              },
              // child: Icon(Icons.delete),
              tooltip: 'Delete',
              backgroundColor: Colors.red,
              child: Text(
                "Delete",
                style: TextStyle(fontSize: 18),
              ),// Change the icon as needed
            ),



          ),

        ],
      ),
    );
  }
}