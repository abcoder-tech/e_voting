import 'dart:convert';
import 'dart:math';
import 'package:e_voting/models/poling_station.dart';
import 'package:e_voting/pages/NEBE/constituencies_list.dart';
import 'package:e_voting/pages/constituencies/constituency_nav_bar.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PollingStationList extends StatefulWidget {
  const PollingStationList({super.key});

  @override
  State<PollingStationList> createState() => _PollingStationListState();
}

class _PollingStationListState extends State<PollingStationList> with SingleTickerProviderStateMixin {
  late Future<List<pollingstation>> futurepollingstation;
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (userId != null) {
        futurepollingstation = fetchpollingstation3(userId!); // Pass userId to the fetch function
      } else {
        print('User ID is null. Cannot fetch polling stations.');
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

  Future<List<pollingstation>> fetchpollingstation3(String userId) async {
    final response = await http.get(
        Uri.parse('${loginPage.apiUrl}pollingstation4?userId=$userId') // Include userId in the API call
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => pollingstation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load polling station');
    }
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
    print('Loaded User ID: $userId'); // For debugging
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Polling Station List"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: constituencyNavbarss(),
      body: FutureBuilder<List<pollingstation>>(
        future: futurepollingstation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Polling Stations found.'));
          }

          final pollingStations = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, bottom: 100),
              child: Column(
                children: List.generate(pollingStations.length, (index) {
                  return _buildAnimatedContainer(context, pollingStations[index]);
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedContainer(BuildContext context, pollingstation pollingStation) {
    return SlideTransition(
      position: _animations[0],
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 230,
              width: 300,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle tap
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
                              "Polling Station Name: ${pollingStation.name}",
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
                                    'Email: ${pollingStation.email}\n'
                                        'Constituency Name: ${pollingStation.constituencies_name}\n'
                                        'Wereda: ${pollingStation.wereda}\n'
                                        'Kebele: ${pollingStation.kebele}\n'
                                        'Number of Voters: \n'
                                        'Description: ${pollingStation.description}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
}