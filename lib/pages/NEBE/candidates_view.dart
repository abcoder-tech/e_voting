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



class candidatesLists extends StatefulWidget {
  final String name; // Use 'final' for immutable fields

   candidatesLists({super.key, required this.name});
  @override
  State<candidatesLists> createState() => _PoliticalPartyListState();
}

class _PoliticalPartyListState extends State<candidatesLists> with SingleTickerProviderStateMixin {
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
        fetchcandidate2(widget.name); // Call fetchcampaign only if userId is not null
      } else {
        print('User ID is null. Cannot fetch campaigns.');
      }
    });
    futurecandidate = fetchcandidate2(widget.name); // Fetch data here
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





  Future<void> _fetchpp() async {
    final response = await http.get(Uri.parse("${loginPage.apiUrl}pp"));
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








  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("${widget.name} Candidates"),
        backgroundColor: Color(0xff2193b0),
      ),
      //drawer: constituencyNavbarss(),
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