import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:e_voting/pages/loginpage.dart';
import 'package:http/http.dart' as http;
import 'package:e_voting/models/candidate.dart';
import 'package:e_voting/models/political_party.dart';
import 'package:e_voting/pages/NEBE/addpoliticalparty.dart';
import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/NEBE/political_party_view.dart';
import 'package:e_voting/pages/constituencies/constituency_nav_bar.dart';

import 'package:e_voting/services/api_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';



class candidatesList extends StatefulWidget {
  const candidatesList({super.key});

  @override
  State<candidatesList> createState() => _PoliticalPartyListState();
}

class _PoliticalPartyListState extends State<candidatesList> with SingleTickerProviderStateMixin {
  List<String> palitical_party = []; // To hold the list of constituency names
  String? selectedpalitical_party;
  late Future<List<candidate>> futurecandidate;
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;
  String? userId;
  XFile? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedFile;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (userId != null) {
        fetchcandidate(); // Call fetchcampaign only if userId is not null
      } else {
        print('User ID is null. Cannot fetch campaigns.');
      }
    });
    futurecandidate = fetchcandidate(); // Fetch data here
    _fetchpp();
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


  void _savecandidate(String candidateid,String candidatesname,String educationlevel, String politicalparty,
      String constituency,
       ) async {
    final request = await http.MultipartRequest(
      'POST',
      Uri.parse("${loginPage.apiUrl}registercandidate"),);

        request.fields['candidateid']= candidateid;
        request.fields['candidatesname']=candidatesname;
        request.fields['educationlevel']= educationlevel;
        request.fields ['politicalparty']= politicalparty;
        request.fields['constituency']= constituency;
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));


      print("${educationlevel}");
    try {
      final response = await request.send();

    if (response.statusCode == 201) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Constituency added successfully.",
      );

      await Future.delayed(Duration(seconds: 1));
      setState(() {
        futurecandidate = fetchcandidate(); // Refresh the list
      });
    } else {
    //  final Map<String, dynamic> errorResponse = jsonDecode(response.body);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "['message']}",
      );
    }
    
  }catch (error) {
     
    }

}


  Future<void> _fetchpp() async {
    final response = await http.get(Uri.parse("${loginPage.apiUrl}pp1"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        // Extract only the names from the response
        palitical_party = data.map((item) => item['name'] as String).toList(); // Adjust if your API response structure is different
      });
    } else {
      // Handle error
      print('Failed to load constituencies: ${response.body}');
    }
  }






  void _showAddConstituencyDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController educationController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
   // String selectedRegion = regions[0];



    String generateCustomId() {
      final random = Random();
      const chars = '0123456789';
      return List.generate(4, (index) => chars[random.nextInt(chars.length)]).join();
    }

    String uniqueId = "CAN"+generateCustomId();
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
                      "Register Candidate",
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
                                decoration: InputDecoration(labelText: 'Candidate Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a Candidate name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: educationController,
                                decoration: InputDecoration(labelText: 'Education Level'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an Education Level';
                                  }

                                  return null;
                                },
                              ),
                              ElevatedButton(
                                onPressed: _pickImage,
                                child: Text('Pick Image'),
                              ),
                              _image != null ? Image.file(File(_image!.path)) : Container(),
                              Row(
                                children: [
                                  Text("Political Party: ", style: TextStyle(fontSize: 18)),
                                  SizedBox(width: 10),
                                  DropdownButton<String>(
                                    value: selectedpalitical_party,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedpalitical_party = newValue!;
                                      });
                                    },
                                    items: palitical_party.map((String POP) {
                                      return DropdownMenuItem<String>(
                                        value: POP,
                                        child: Text(POP),
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
                  _savecandidate(
                    uniqueId,
                    nameController.text,
                    educationController.text,
                    selectedpalitical_party!,
                      userId!,

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Candidate"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: constituencyNavbarss(),
      body: FutureBuilder<List<candidate>>(
        future: futurecandidate,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Candidate found.'));
          }

          final can = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, bottom: 100),
              child: Column(
                children: List.generate(can.length, (index) {
                  return _buildAnimatedContainer(context, can[index]);
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
          onPressed:(){ _showAddConstituencyDialog(context);
            },
          tooltip: 'Add Party',
          backgroundColor: Colors.green,
          child: Text("Add Candidate", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(BuildContext context, candidate candidatee) {
    return SlideTransition(
      position: _animations[0], // Adjust as needed
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 270,
              width: 300,
              decoration: BoxDecoration(color: Colors.white),
              child: GestureDetector(
                onTap: () {
                 // Navigator.push(context, MaterialPageRoute(builder: (context) => viewparty(email: candidate.,name: party.name,img:party.ima)));
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
                          image: candidatee.ima != null ? MemoryImage(base64Decode(candidatee.ima!)) : AssetImage('lib/images/default.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 150, left: 40),
                      child: Container(

                        height: 200,
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
                          padding: const EdgeInsets.only(bottom: 10,top: 10 ,left: 20,),
                          child: Text(
                            'Candidate ID: ${candidatee.candidateid}\n'
                            'Candidate Name: ${candidatee.candidatesname}\n'
                              'Education Level: ${candidatee.educationlevel}\n'
                                  'Political Party: ${candidatee.politicalparty}\n'
                                'Constituency: ${candidatee.constituency}\n'


                             ,
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