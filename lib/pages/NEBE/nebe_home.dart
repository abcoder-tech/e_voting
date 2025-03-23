import 'package:e_voting/pages/NEBE/constituencies_list.dart';
import 'package:e_voting/pages/NEBE/political_party_list.dart';
import 'package:e_voting/pages/NEBE/polling_station_list.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/political_party.dart';
import 'package:e_voting/models/political_party.dart';

import 'package:e_voting/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:e_voting/pages/loginpage.dart';

import 'package:readmore/readmore.dart';

class NebeHome extends StatefulWidget {
  const NebeHome({super.key});

  @override
  State<NebeHome> createState() => _NebeHomeState();
}

class _NebeHomeState extends State<NebeHome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;
  int _politicalPartyCount = 0;
  int _voterCount = 0;
  int _constituencyCount = 0;
  int _pollignstationCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Initialize animations for each container
    _animations = List.generate(4, (index) {
      return Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2, // Stagger the start times
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    // Start the animation
    _controller.forward();
    _fetchPoliticalPartyCount();
    _fetchpollingstationCount();
    _fetchConstituenyCount();
  }


  Future<void> _fetchPoliticalPartyCount() async {
    try {
      final response = await http.get(Uri.parse('${loginPage.apiUrl}countparties')); // Update with your actual endpoint
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _politicalPartyCount = jsonResponse['count']; // Adjust based on your API response
        });
      } else {
        throw Exception('Failed to load political party count');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  Future<void> _fetchConstituenyCount() async {
    try {
      final response = await http.get(Uri.parse('${loginPage.apiUrl}countconstituency')); // Update with your actual endpoint
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _constituencyCount = jsonResponse['count']; // Adjust based on your API response
        });
      } else {
        throw Exception('Failed to load political party count');
      }
    } catch (e) {
      print('Error: $e');
    }
  }







  Future<void> _fetchpollingstationCount() async {
    try {
      final response = await http.get(Uri.parse('${loginPage.apiUrl}countpollingstation')); // Update with your actual endpoint
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _pollignstationCount = jsonResponse['count']; // Adjust based on your API response
        });
      } else {
        throw Exception('Failed to load political party count');
      }
    } catch (e) {
      print('Error: $e');
    }
  }






  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseRadius = screenWidth * 0.05;

     return WillPopScope(
        onWillPop: () async {
      // Prevent back navigation
      return false;
    },child: Scaffold(
      backgroundColor: Color(0xff2193b0),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff2193b0),
                ),
                height: screenHeight * 0.1,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/images/nebe banner.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(baseRadius * 6.5),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
                      child: Column(
                        children: [
                          _buildAnimatedContainer("6571 Voters", 'lib/images/voter.jpg', screenHeight, screenWidth, baseRadius, 0),
                          SizedBox(height: screenHeight * 0.02),
                          _buildAnimatedContainer("$_politicalPartyCount Political Parties", 'lib/images/political party.jpg', screenHeight, screenWidth, baseRadius, 1,onTap: () {
    // Define what happens when the container is tapped
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PoliticalPartyList()), // Replace with your actual destination page
    );
    },),
                          SizedBox(height: screenHeight * 0.02, ),
                          _buildAnimatedContainer("$_constituencyCount constituencies", 'lib/images/region.webp', screenHeight, screenWidth, baseRadius, 2,onTap: () {
    // Define what happens when the container is tapped
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ConstituencyList()), // Replace with your actual destination page
    );
    },),
                          SizedBox(height: screenHeight * 0.02),
                          _buildAnimatedContainer("$_pollignstationCount polling Stations", 'lib/images/poling sation.webp', screenHeight, screenWidth, baseRadius, 3,onTap: () {
                            // Define what happens when the container is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PollingStationList()), // Replace with your actual destination page
                            );
                          },),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildAnimatedContainer(String title, String imagePath, double screenHeight, double screenWidth, double baseRadius, int index, {Function()? onTap}) {
    return SlideTransition(
      position: _animations[index],
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Container(
            height: screenHeight * 0.25,
            width: screenWidth * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(baseRadius)),
              color: Colors.grey,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.21),
              child: Container(
                color: Color(0xff2193b0),
                width: screenWidth * 0.85,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


