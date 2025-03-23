import 'dart:convert';
import 'dart:math';
import 'package:e_voting/models/Constituency.dart';
import 'package:e_voting/pages/NEBE/constituencies_view.dart';
import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;

class ConstituencyList extends StatefulWidget {
  const ConstituencyList({super.key});

  @override
  State<ConstituencyList> createState() => _ConstituencyListState();
}

class _ConstituencyListState extends State<ConstituencyList> {
  late Future<List<Constituency>> futureConstituencies;
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
  // Track expanded states for constituencies
  List<bool> expandedStates = [];

  @override
  void initState() {
    super.initState();
    futureConstituencies = fetchConstituencies();
  }

  Future<int> fetchPollingStationCount(String constituencies_name) async {
    final response = await http.get(Uri.parse("${loginPage.apiUrl}countpollingstation/$constituencies_name"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['count'];
    } else {
      throw Exception('Failed to load polling station count');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Constituencies"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: Navbarss(),
      body: FutureBuilder<List<Constituency>>(
        future: futureConstituencies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No constituencies found.'));
          }

          final constituencies = snapshot.data!;
          expandedStates = List.generate(constituencies.length, (index) => false); // Initialize expanded states

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, bottom: 100),
              child: Column(
                children: List.generate(constituencies.length, (index) {
                  return FutureBuilder<int>(
                    future: fetchPollingStationCount(constituencies[index].name), // Fetch count here
                    builder: (context, countSnapshot) {
                      if (countSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading indicator while fetching the count
                      } else if (countSnapshot.hasError) {
                        return Text('Error: ${countSnapshot.error}');
                      }

                      final pollingStationCount = countSnapshot.data ?? 0; // Default to 0 if null
                      return _buildExpandableContainer(context, constituencies[index], pollingStationCount, index);
                    },
                  );
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
            _showAddConstituencyDialog(context);
          },
          tooltip: 'Add Constituency',
          backgroundColor: Colors.green,
          child: Text("Add", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildExpandableContainer(BuildContext context, Constituency constituency, int pollingStationCount, int index) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => viewconstituency(
                  ID: constituency.ID,
                  email: constituency.email,
                  name: constituency.name,
                  description: constituency.description,
                  region: constituency.region,
                  no_polling: pollingStationCount
              )));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 200,
              width: 300,
              decoration: BoxDecoration(color: Colors.white),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      color: Colors.greenAccent,
                    ),
                    height: 100,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 40),
                      child: Text(
                        "Constituency Name: ${constituency.name}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 0),
                    child: Container(
                      height: 150,
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
                              'Email: ${constituency.email}\n'
                                  'Region: ${constituency.region}\n'
                                  'Number of polling station: $pollingStationCount\n'
                                  'Number of candidates: \n'
                                  'Number of voter: \n'
                                  'Description: ${constituency.description}',
                              style: TextStyle(fontSize: 18),
                            ),
                            // Show buttons only if expanded
                            if (expandedStates[index]) ...[
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                    //  _showUpdateConstituencyDialog(context, constituency);
                                    },
                                    child: Text('Update'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      //_showDeleteConfirmationDialog(context, constituency.name);
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  void _showAddConstituencyDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String selectedRegion = regions[0];

    String generateCustomId() {
      final random = Random();
      const chars = '0123456789';
      return List.generate(4, (index) => chars[random.nextInt(chars.length)]).join();
    }

    String uniqueId = "CON"+generateCustomId();
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
                  height: 100,
                  padding: EdgeInsets.all(18),
                  child: Center(
                    child: Text(
                      "Add Constituency",
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
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
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
                  _saveConstituency(
                    uniqueId,
                    nameController.text,
                    emailController.text,
                    descriptionController.text,
                    passwordController.text,
                    selectedRegion,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _saveConstituency(String ID, String name, String email, String description, String password, String region) async {
    final response = await http.post(
      Uri.parse("${loginPage.apiUrl}registerConstituency"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'ID': ID,
        'name': name,
        'email': email,
        'description': description,
        'password': password,
        'region': region,
      }),
    );

    if (response.statusCode == 201) {
      final registeredData = json.decode(response.body); // Assuming the API returns the created data
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Constituency added successfully.\n\n"
            "ID: $ID \n"
            "Name: $name \n"
            "Email: $email\n"
            "Description: $description\n"
            "Region: $region",
      );

      await Future.delayed(Duration(seconds: 1));
      setState(() {
        futureConstituencies = fetchConstituencies(); // Refresh the list
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
}