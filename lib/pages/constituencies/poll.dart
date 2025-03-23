import 'dart:async';
import 'dart:convert';
import 'package:e_voting/pages/constituencies/count.dart';
import 'package:e_voting/pages/loginpage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Schedule class definition
class Schedule {
  final String scheduleid;
  final String electionId;
  final String electionName;
  final DateTime candidateRegStartDate;
  final DateTime candidateRegEndDate;
  final DateTime electionCampaignStartDate;
  final DateTime electionCampaignEndDate;
  final DateTime voterRegStartDate;
  final DateTime voterRegEndDate;
  final DateTime attentionTimeStartDate;
  final DateTime attentionTimeEndDate;
  final DateTime votingStartDate;
  final DateTime votingEndDate;
  final DateTime resultAnnouncementStartDate;
  final DateTime resultAnnouncementEndDate;

  Schedule({
    required this.scheduleid,
    required this.electionId,
    required this.electionName,
    required this.candidateRegStartDate,
    required this.candidateRegEndDate,
    required this.electionCampaignStartDate,
    required this.electionCampaignEndDate,
    required this.voterRegStartDate,
    required this.voterRegEndDate,
    required this.attentionTimeStartDate,
    required this.attentionTimeEndDate,
    required this.votingStartDate,
    required this.votingEndDate,
    required this.resultAnnouncementStartDate,
    required this.resultAnnouncementEndDate,
  });
}

class BallotPage extends StatefulWidget {
  final String electionId;
  const BallotPage({super.key, required this.electionId});
  @override
  _BallotPageState createState() => _BallotPageState();
}

class _BallotPageState extends State<BallotPage> {
  Timer? _timer;
  List<Schedule> schedules = [];
  List<dynamic> ballotItems = [];
  String? selectedCandidate; // Variable to hold selected candidate
  String votingStatusMessage = '';
  bool isLoading = true;
  String? userId;// Loading state

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (userId != null) {
        fetchBallot(); // Call fetchcampaign only if userId is not null
      } else {
        print('User ID is null. Cannot fetch disputes.');
      }
    });

    _startTimer(); // Start the timer when the page is initialized
  }






  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
    print('Loaded User ID: $userId'); // For debugging
  }





  Future<void> fetchBallot() async {
    final response = await http.get(Uri.parse('${loginPage.apiUrl}ballot/${widget.electionId}'));
    final responsee = await http.get(Uri.parse('${loginPage.apiUrl}elections/${widget.electionId}'));

    if (responsee.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(responsee.body);

      setState(() {
        schedules = [];

        for (var election in jsonData) {
          var candidateReg = election['schedules']['candidateReg'];
          var electionCampaign = election['schedules']['electionCampaign'];
          var voterReg = election['schedules']['voterReg'];
          var attentionTime = election['schedules']['attentionTime'];
          var voting = election['schedules']['voting'];
          var resultAnnouncement = election['schedules']['resultAnnouncement'];

          Schedule schedule = Schedule(
            scheduleid: election['_id'],
            electionId: election['electionId'],
            electionName: election['electionName'],
            candidateRegStartDate: DateTime.parse(candidateReg['startDate']),
            candidateRegEndDate: DateTime.parse(candidateReg['endDate']),
            electionCampaignStartDate: DateTime.parse(electionCampaign['startDate']),
            electionCampaignEndDate: DateTime.parse(electionCampaign['endDate']),
            voterRegStartDate: DateTime.parse(voterReg['startDate']),
            voterRegEndDate: DateTime.parse(voterReg['endDate']),
            attentionTimeStartDate: DateTime.parse(attentionTime['startDate']),
            attentionTimeEndDate: DateTime.parse(attentionTime['endDate']),
            votingStartDate: DateTime.parse(voting['startDate']),
            votingEndDate: DateTime.parse(voting['endDate']),
            resultAnnouncementStartDate: DateTime.parse(resultAnnouncement['startDate']),
            resultAnnouncementEndDate: DateTime.parse(resultAnnouncement['endDate']),
          );

          schedules.add(schedule);
        }
      });
    } else {
      print('Failed to load schedules');
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Response: $data'); // Log the entire response

      // Check if the response has the 'ballot' key and is a list
      if (data is Map && data.containsKey('ballot') && data['ballot'] is List) {
        setState(() {
          ballotItems = data['ballot']; // Set ballot items from the 'ballot' key
          isLoading = false; // Data has been loaded
        });
      } else {
        print('Error: Expected a list for ballot items, but got ${data}');
      }
    } else {
      throw Exception('Failed to load ballot');
    }
  }

  void vote() async {
    if (selectedCandidate != null) {
      // Find the selected candidate's details
      final selectedCandidateDetails = ballotItems.firstWhere(
            (item) => item['candidateName'] == selectedCandidate,
        orElse: () => null,
      );

      if (selectedCandidateDetails != null) {
        final voteData = {
          'userid': userId, // Replace with actual user ID
          'politicalparty': selectedCandidateDetails['politicalPartyName'], // Get political party name
          //'constituency': 'CONSTITUENCY_NAME', // Replace with actual constituency
          'candidate': selectedCandidateDetails['candidateName'],
          // 'polingstation': 'POLLING_STATION_NAME', // Replace with actual polling station
          'electionid': widget.electionId, // Replace with actual election ID
        };

        final response = await http.post(
          Uri.parse('${loginPage.apiUrl}vote'), // Replace with your server's IP
          headers: {'Content-Type': 'application/json'},
          body: json.encode(voteData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vote recorded successfully!')),
          );
        } else {
          // Directly decode the response body
          final Map<String, dynamic> responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected candidate details not found.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a candidate to vote.')),
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        votingStatusMessage = '';
        bool hasEnded = false;

        for (var schedule in schedules) {
          final now = DateTime.now();
          final remainingTimeToStart = schedule.votingStartDate.difference(now);
          final remainingTimeToEnd = schedule.votingEndDate.difference(now);

          if (remainingTimeToEnd.isNegative) {
            hasEnded = true; // Voting period has ended
          } else if (remainingTimeToStart.isNegative) {
            votingStatusMessage = 'Voting is active.';
          } else {
            votingStatusMessage = 'Voting has not started yet.\nPlease come back after ' + formatDuration(remainingTimeToStart) + ' to start.';
          }
        }

        // Check if voting has ended and navigate to CandidateCountScreen
        if (hasEnded) {
          _timer?.cancel(); // Stop the timer
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CandidateCountScreen(electionId: widget.electionId), // Pass electionId
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing of the widget
    super.dispose();
  }

  String formatDuration(Duration duration) {
    if (duration.isNegative) return 'Time has passed';

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while data is being fetched
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Ballot'),
        ),
        body: Center(child: CircularProgressIndicator()), // Loading indicator
      );
    }

    bool isVotingActive = votingStatusMessage == 'Voting is active.';

    return Scaffold(
      appBar: AppBar(
        title: Text('Ballot'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only( left: 50, right: 50),
              child: Column(
                children: [
                  Text(
                    votingStatusMessage,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>uuserAnnouncementList()));

                ],
              ),
            ),
            if (isVotingActive) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ballotItems.length,
                itemBuilder: (context, index) {
                  final item = ballotItems[index];
                  print('Item: $item'); // Debugging line to check item structure

                  // Ensure item is a Map
                  if (item is! Map) {
                    return Container(); // Handle unexpected item type
                  }

                  return RadioListTile<String>(
                    value: item['candidateName'],
                    groupValue: selectedCandidate,
                    onChanged: (value) {
                      setState(() {
                        selectedCandidate = value; // Update selected candidate
                      });
                    },
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Display the candidate's image
                            if (item['candidateImage'] != null && item['candidateImage']['data'] != null)
                              Image.memory(
                                base64Decode(item['candidateImage']['data']),
                                width: 74,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(width: 8), // Spacing between candidate and party images
                            // Display the political party's image
                            if (item['politicalPartyImage'] != null && item['politicalPartyImage']['data'] != null)
                              Image.memory(
                                base64Decode(item['politicalPartyImage']['data']),
                                width: 75,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Text(item['candidateName'] ?? 'Unknown Candidate', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(item['politicalPartyName'] ?? 'Unknown Party', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            ],
                          ),
                        ) // Spacing between images and names
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: vote,
                  child: Text('Vote'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}