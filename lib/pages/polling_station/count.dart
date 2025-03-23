import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CandidateCountScreen extends StatefulWidget {
  final String electionId; // Accept election ID

  CandidateCountScreen({Key? key, required this.electionId}) : super(key: key);

  @override
  _CandidateCountScreenState createState() => _CandidateCountScreenState(electionId);
}

class _CandidateCountScreenState extends State<CandidateCountScreen> {
  List<Map<String, dynamic>> results = [];
  final String electionId;

  _CandidateCountScreenState(this.electionId);

  @override
  void initState() {
    super.initState();
    fetchCandidateCounts(electionId);
  }
  Future<void> fetchCandidateCounts(String electionId) async {
    try {
      // Build the URL with the election ID as a query parameter
      final response = await http.get(Uri.parse('${loginPage.apiUrl}candidatescount?electionId=$electionId'));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          // Map the data to your results structure
          results = data.map((item) => {
            'constituency': item['constituency'],
            'totalVotes': item['totalVotes'],
            'candidates': item['candidates'],
            'winner': item['winner'],
            'message': item['message'],
          }).toList();
        });
      } else {
        print('Failed to load candidate counts: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Election Result'),
      ),
      body: results.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          var result = results[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Constituency: ${result['constituency']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text("Total Votes: ${result['totalVotes']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text("Winner: ${result['winner']['name']} from ${result['winner']['party']} with ${result['winner']['count']} votes", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(result['message'], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text("Candidates:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ...result['candidates'].map<Widget>((candidate) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text("${candidate['name']} (${candidate['party']}): ${candidate['count']}", style: TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

