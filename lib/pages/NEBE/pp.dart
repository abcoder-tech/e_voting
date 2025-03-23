import 'dart:convert';


import 'package:flutter/material.dart';
import '../../models/political_party.dart';
import '../../services/api_service.dart';

class pp extends StatefulWidget {
  const pp({super.key});
  @override
  State<pp> createState() => _PoliticalPartyListState();
}

class _PoliticalPartyListState extends State<pp> {
  late Future<List<PoliticalParty>> futureParties;

  @override
  void initState() {
    super.initState();
    futureParties = fetchPoliticalParties();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Political Parties')),
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

          return ListView.builder(
            itemCount: parties.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(parties[index].name),
                subtitle: Text(parties[index].email),
                leading: parties[index].ima != null
                    ? CircleAvatar(
                  backgroundImage: MemoryImage(base64Decode(parties[index].ima!)),
                )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}