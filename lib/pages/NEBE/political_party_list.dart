import 'dart:convert';
import 'package:e_voting/models/political_party.dart';
import 'package:e_voting/pages/NEBE/addpoliticalparty.dart';
import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/NEBE/political_party_view.dart';
import 'package:e_voting/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PoliticalPartyList extends StatefulWidget {
  const PoliticalPartyList({super.key});

  @override
  State<PoliticalPartyList> createState() => _PoliticalPartyListState();
}

class _PoliticalPartyListState extends State<PoliticalPartyList> with SingleTickerProviderStateMixin {
  late Future<List<PoliticalParty>> futureParties;
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    futureParties = fetchPoliticalParties(); // Fetch data here

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
        title: Text("Political Parties"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: Navbarss(),
      body: FutureBuilder<List<PoliticalParty>>(
        future: futureParties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No political parties found.'));
          }

          final parties = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, bottom: 100),
              child: Column(
                children: List.generate(parties.length, (index) {
                  return _buildAnimatedContainer(context, parties[index]);
                }),
              ),
            ),
          );
        }, //
      ),
      floatingActionButton: Container(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            _showAddPoliticalPartyDialog();
            },
          tooltip: 'Add Party',
          backgroundColor: Colors.green,
          child: Text("Add Party", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  void _showAddPoliticalPartyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: addpoliticalparty(),
        );
      },
    ).then((_) {
      // Refresh the list after adding a party
      setState(() {
        futureParties = fetchPoliticalParties();
      });
    });
  }

  Widget _buildAnimatedContainer(BuildContext context, PoliticalParty party) {
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewparty(email: party.email, name: party.name, img: party.ima)));
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
                          image: party.ima != null ? MemoryImage(base64Decode(party.ima!)) : AssetImage('lib/images/default.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 160, left: 40),
                      child: Container(
                        height: 70,
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
                            'Party Name: ${party.name}\nEmail: ${party.email}', // Display dynamic data
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