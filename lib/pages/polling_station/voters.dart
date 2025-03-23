import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:e_voting/models/voterss.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/polling_station/polling_station_nav_bar.dart';
import 'package:e_voting/pages/voter/voter_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:e_voting/pages/NEBE/nav_bar.dart';
//import 'package:e_voting/pages/constituencies/constituency_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VotersList extends StatefulWidget {
  const VotersList({super.key});

  @override
  State<VotersList> createState() => _VotersListState();
}

class _VotersListState extends State<VotersList> with SingleTickerProviderStateMixin {
  late Future<List<Voter>> futureVoters = Future.value([]); // Initialize with an empty list
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;
  List<bool> _expandedVoterIndices = [];
  String? userId;
  XFile? _image;
  String? selectedSex;// Variable to hold selected sex

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera); // Use camera to take a picture

    setState(() {
      _image = pickedFile;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (userId != null) {
        futureVoters = fetchVoters(); // Fetch voters only if userId is not null
      } else {
        print('User ID is null. Cannot fetch voters.');
      }
    });

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

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
    print('Loaded User ID: $userId'); // For debugging
  }

  Future<List<Voter>> fetchVoters() async {
    // Ensure userId is not null before making the request
    if (userId == null) {
      throw Exception('User ID is null. Cannot fetch voters.');
    }

    // Create the URL with userId as a query parameter
    final response = await http.get(
        Uri.parse("${loginPage.apiUrl}voterss?userId=$userId") // Append userId to the endpoint
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((json) => Voter.fromJson(json)).toList(); // Update this line according to your model
    } else {
      throw Exception('Failed to load voters');
    }
  }

  void _saveVoter(String voterId, String voterName, String password, int age, String sex) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("${loginPage.apiUrl}registervoter"), // Your API endpoint
    );

    request.fields['voterId'] = voterId;
    request.fields['voterName'] = voterName;
    request.fields['password'] = password; // Include the password field
    request.fields['age'] = age.toString();
    request.fields['sex'] = sex; // Include the sex field

    // Log the userId to ensure it's correct
    print("User ID: $userId");
    if (userId == null) {
      print("User ID is null, cannot send to backend.");
    }
    request.fields['userId'] = userId!; // Include the user ID

    // Convert the image to Base64 and add it to the request fields
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    // Log the entire request fields
    print("Request Fields: ${request.fields}");

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Voter registered successfully.",
        );

        await Future.delayed(Duration(seconds: 1));
        setState(() {
          futureVoters = fetchVoters(); // Refresh the list
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Failed to register voter.",
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showAddVoterDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController passwordController = TextEditingController(); // New password controller

    String generateCustomId() {
      final random = Random();
      const chars = '0123456789';
      return List.generate(4, (index) => chars[random.nextInt(chars.length)]).join();
    }

    String uniqueId = "VOT" + generateCustomId();
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
                      "Register Voter",
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Voter Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Voter name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: ageController,
                            decoration: InputDecoration(labelText: 'Age'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an Age';
                              }
                              int age = int.tryParse(value) ?? 0;
                              if (age < 18 || age > 100) {
                                return 'Age must be between 18 and 100';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true, // Hide the password
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Password';
                              }
                              // Password validation rules
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return 'Password must contain at least one number';
                              }
                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                                return 'Password must contain at least one special character';
                              }
                              return null;
                            },
                          ),
                          // Sex selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Sex: ', style: TextStyle(fontSize: 16)),
                              Radio<String>(
                                value: 'Male',
                                groupValue: selectedSex,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSex = value;
                                  });
                                },
                              ),
                              Text('Male'),
                              Radio<String>(
                                value: 'Female',
                                groupValue: selectedSex,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSex = value;
                                  });
                                },
                              ),
                              Text('Female'),
                            ],
                          ),
                          // Validation for sex
                          if (selectedSex == null)
                            Text(
                              'Please select your sex',
                              style: TextStyle(color: Colors.red),
                            ),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text('Take Picture'),
                          ),
                          _image != null ? Image.file(File(_image!.path)) : Container(),
                        ],
                      ),
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
                if (_formKey.currentState!.validate() && selectedSex != null) {
                  _saveVoter(
                    uniqueId,
                    nameController.text,
                    passwordController.text, // Save the password
                    int.parse(ageController.text),
                    selectedSex!,
                    // Save the selected sex
                  );
                  Navigator.of(context).pop();
                } else if (selectedSex == null) {
                  // Show error if sex is not selected
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: "Please select your sex.",
                  );
                }
              },
              child: Text('Register', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voters"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: pollingstationNavbarss(),
      body: FutureBuilder<List<Voter>>(
        future: futureVoters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Voters found.'));
          }

          final voters = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, bottom: 100),
              child: Column(
                children: List.generate(voters.length, (index) {
                  return _buildAnimatedContainer(context, voters[index]);
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
            _showAddVoterDialog(context);
          },
          tooltip: 'Add Voter',
          backgroundColor: Colors.green,
          child: Text("Add Voter", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(BuildContext context, Voter voter) {
    return SlideTransition(
      position: _animations[0], // Adjust as needed
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 300,
              width: 300,
              decoration: BoxDecoration(color: Colors.white),
              child: GestureDetector(
                onTap: () {
                  // Handle tap if needed
                },
                child: Stack(
                  children: [
                    Container(
                      height: 180,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: voter.ima != null ? MemoryImage(base64Decode(voter.ima!)) : AssetImage('lib/images/default.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 150, left: 40),
                      child: Container(
                        height: 300,
                        width: 230,
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
                          padding: const EdgeInsets.only(bottom: 10, top: 10, left: 20),
                          child: Text(
                            'Voter ID: ${voter.voterId}\n'
                                'Voter Name: ${voter.voterName}\n'
                                'Age: ${voter.age}\n'
                                'Sex: ${voter.sex}\n'
                                'Constituency Name: ${voter.constituency}\n'
                                'Pollingstation name: ${voter.pollingStation}\n'
                                , // Assuming your Voter model includes a sex field
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}