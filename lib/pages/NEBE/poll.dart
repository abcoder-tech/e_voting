import 'dart:convert';
import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PoliticalParty {
  final String name;
  final String email;
  final String? ima;

  PoliticalParty({required this.name, required this.email, required this.ima});

  factory PoliticalParty.fromJson(Map<String, dynamic> json) {
    return PoliticalParty(
      name: json['name'],
      email: json['email'],
      ima: json['img'] != null ? json['img']['data'] : null, // Adjust based on your API response
    );
  }
}

Future<List<PoliticalParty>> fetchPoliticalParties() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}politicalparties'));
  print("aaaa");
  if (response.statusCode == 200) {
    print("bbb");
    final List<dynamic> jsonData = json.decode(response.body)['data'];
    return jsonData.map((party) => PoliticalParty.fromJson(party)).toList();
  } else {
    throw Exception('Failed too load political parties');
  }
}

class PollPage extends StatefulWidget {
  @override
  _PollPageState createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  late Future<List<PoliticalParty>> futureParties;
  Map<String, bool> selectedParties = {};

  @override
  void initState() {
    super.initState();
    futureParties = fetchPoliticalParties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vote for Your Option"),
        backgroundColor:  Color(0xff2193b0),
        //backgroundColor: Colors.blueGrey,
      ),
      drawer: Navbarss(),
      body: FutureBuilder<List<PoliticalParty>>(
        future: futureParties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final parties = snapshot.data!;
            return ListView(
              padding: EdgeInsets.only(top: 20,right: 10),
              children: parties.map((party) {
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 230,
                  width: 300,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Checkbox(
                        value: selectedParties[party.name] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedParties[party.name] = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 230,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 15,
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: 180,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(
                                      image: party.ima != null
                                          ? MemoryImage(base64Decode(party.ima!))
                                          : AssetImage('lib/images/default.jpg'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 160, left: 40),
                                  child: Container(
                                    height: 50,
                                    width: 200,
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
                                      padding: const EdgeInsets.only(bottom: 0, top: 0, left: 0),
                                      child: Center(
                                        child: Text(
                                          'Party Name: ${party.name}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
