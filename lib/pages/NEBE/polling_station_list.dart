import 'dart:convert';
import 'dart:math';

// Update to your constituency model
// Update to your add constituency page

import 'package:e_voting/models/poling_station.dart';
import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/loginpage.dart';
// Update to your constituency view page
import 'package:http/http.dart' as http;
import 'package:e_voting/services/api_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class PollingStationList extends StatefulWidget {
  const PollingStationList({super.key});

  @override
  State<PollingStationList> createState() => _PollingStationListState();
}

class _PollingStationListState extends State<PollingStationList> with SingleTickerProviderStateMixin {
  late Future<List<pollingstation>> futurepollingstation;
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;
  List<String> constituencies = []; // To hold the list of constituency names
  String? selectedConstituency;


  @override
  void initState() {
    super.initState();
    futurepollingstation = fetchpollingstation(); // Fetch data here
    _fetchConstituencies();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animations = List.generate(2, (index) {
      return Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PollingStationList"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: Navbarss(),
      body: FutureBuilder<List<pollingstation>>(
        future: futurepollingstation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erroor: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No PollingStation found.'));
          }

          final PollingStation = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, bottom: 100),
              child: Column(
                children: List.generate(PollingStation.length, (index) {
                  return _buildAnimatedContainer(context, PollingStation[index]);
                }),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Container(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            _showAddpollingstationDialog(context);//  Navigator.push(context, MaterialPageRoute(builder: (context) => AddConstituency())); // Change to add constituency page
          },
          tooltip: 'Add Constituency',
          backgroundColor: Colors.green,
          child: Text("Add", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }








  Future<void> _fetchConstituencies() async {
    final response = await http.get(Uri.parse("${loginPage.apiUrl}pp"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        // Extract only the names from the response
        constituencies = data.map((item) => item['name'] as String).toList(); // Adjust if your API response structure is different
      });
    } else {
      // Handle error
      print('Failed to load constituencies: ${response.body}');
    }
  }





  void _showAddpollingstationDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController constituencies_nameController = TextEditingController();
    final TextEditingController weredaController = TextEditingController();
    final TextEditingController kebeleController = TextEditingController();
   // String selectedRegion = regions[0];



    String generateCustomId() {
      final random = Random();
      const chars = '0123456789';
      return List.generate(4, (index) => chars[random.nextInt(chars.length)]).join();
    }

    String uniqueId ="PS"+ generateCustomId();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
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
                      "Register Polling station",
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
                                decoration: InputDecoration(labelText: 'Polling Station Name'),
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
                                controller: descriptionController,
                                decoration: InputDecoration(labelText: 'Description'),
                              ),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(labelText: 'Password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) { // Password must be at least 6 characters long
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                            DropdownButtonFormField<String>(
                              value: selectedConstituency,
                              decoration: InputDecoration(labelText: 'Constituency'),
                              items: constituencies.map((String constituency) {
                                return DropdownMenuItem<String>(
                                  value: constituency,
                                  child: Text(constituency),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedConstituency = newValue; // Update selected constituency
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a constituency';
                                }
                                return null;
                              },
                            ),
                              TextFormField(
                                controller: weredaController,
                                decoration: InputDecoration(labelText: 'Wereda'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a constituency name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: kebeleController,
                                decoration: InputDecoration(labelText: 'Kebele'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a constituency name';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _savepollingstation(
                    uniqueId,
                    nameController.text,
                    emailController.text,
                    descriptionController.text,
                    passwordController.text,
                    selectedConstituency!,
                    weredaController.text,
                    kebeleController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Register', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }




  void _savepollingstation(String ID, String name, String email,
      String description, String password, String constituencies_name,
      String wereda, String kebele) async {
    final response = await http.post(
      Uri.parse("${loginPage.apiUrl}registerpollingstation"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'ID': ID,
        'name': name,
        'email': email,
        'description': description,
        'password': password,
        'constituencies_name': constituencies_name,
        'wereda': wereda,
        'kebele': kebele,
      }),
    );

    if (response.statusCode == 201) {
      final registeredData = json.decode(response.body); // Assuming the API returns the created data
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Polling station added successfully.\n\n"
            "User Id : $ID\n"
            "Name: $name\n"
            "Email: $email\n"
            "Constituency: $constituencies_name\n"
            "Wereda: $wereda\n"
            "Kebele: $kebele\n"
            "Description: $description",
      );

      setState(() {
        futurepollingstation = fetchpollingstation(); // Refresh the list
      });
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "${errorResponse['message']}",
      );
    }
  }





  Widget _buildAnimatedContainer(BuildContext context, pollingstation Pollingstation) {
    return SlideTransition(
      position: _animations[0], // Adjust as needed
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 230,
              width: 300,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [GestureDetector(
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ConstituencyView(email: constituency.email, name: constituency.name, img: constituency.img))); // Update to constituency view page
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                          color: Colors.greenAccent,
                        ),
                        height: 50,
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 40),
                          child: Text(
                            "Polling station Name: ${Pollingstation.name}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 0),
                        child: Container(
                          height:  150 ,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
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
                            padding: const EdgeInsets.only(bottom: 10, top: 10, left: 20),
                            child: Column(
                              children: [
                                Text(
                                  'Email: ${Pollingstation.email}\n'
                                      'Constituencies Name : ${Pollingstation.constituencies_name}\n'
                                      'Wereda: ${Pollingstation.wereda}\n'
                                      'Wereda: ${Pollingstation.kebele}\n'
                                      'Number of voters: \n'
                                      'Description: '
                                      '${Pollingstation.description}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                // Show buttons only if expanded

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

            ]
              ),

            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}