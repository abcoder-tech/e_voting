import 'dart:convert';
import 'dart:math';
import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ElectionInputFlow extends StatefulWidget {
  @override
  _ElectionInputFlowState createState() => _ElectionInputFlowState();
}

class _ElectionInputFlowState extends State<ElectionInputFlow> {
  final TextEditingController _electionNameController = TextEditingController();
  List<String> _constituencies = [];
  List<String> _politicalParties = [];
  Map<String, bool> _selectedConstituencies = {};
  Map<String, bool> _selectedParties = {};

  // Schedule fields for different events
  DateTime? _candidateRegStartDate;
  DateTime? _candidateRegEndDate;
  DateTime? _electionCampaignStartDate;
  DateTime? _electionCampaignEndDate;
  DateTime? _voterRegStartDate;
  DateTime? _voterRegEndDate;
  DateTime? _attentionStartDate;
  DateTime? _attentionEndDate;
  DateTime? _votingStartDate;
  DateTime? _votingEndDate;
  DateTime? _resultAnnounceStartDate;
  DateTime? _resultAnnounceEndDate;
  String? _candidateRegError;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _fetchConstituencies();
    _fetchPoliticalParties();
  }

  Future<void> _fetchConstituencies() async {
    try {
      final response = await http.get(Uri.parse('${loginPage.apiUrl}Constituency'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _constituencies = jsonData.map((json) => json['name'] as String).toList();
          for (var constituency in _constituencies) {
            _selectedConstituencies[constituency] = false;
          }
        });
      } else {
        throw Exception('Failed to load constituencies');
      }
    } catch (e) {
      print('Error fetching constituencies: $e');
    }
  }

  Future<void> _fetchPoliticalParties() async {
    try {
      final response = await http.get(Uri.parse('${loginPage.apiUrl}politicalparties'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status']) {
          final List<dynamic> jsonData = jsonResponse['data'];
          setState(() {
            _politicalParties = jsonData.map((json) => json['name'] as String).toList();
            for (var party in _politicalParties) {
              _selectedParties[party] = false;
            }
          });
        } else {
          throw Exception('Failed to load political parties');
        }
      } else {
        throw Exception('Failed to load political parties');
      }
    } catch (e) {
      print('Error fetching political parties: $e');
    }
  }

  void _submitElectionDetails() async {
    String electionName = _electionNameController.text;

    // Validate required fields
    if (electionName.isEmpty ||
        _candidateRegStartDate == null || _candidateRegEndDate == null ||
        _electionCampaignStartDate == null || _electionCampaignEndDate == null ||
        _voterRegStartDate == null || _voterRegEndDate == null ||
        _attentionStartDate == null || _attentionEndDate == null ||
        _votingStartDate == null || _votingEndDate == null ||
        _resultAnnounceStartDate == null || _resultAnnounceEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Additional validation to check date constraints
    if (_candidateRegStartDate!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Candidate registration start date cannot be in the past.')),
      );
      return;
    }
    if (_candidateRegEndDate!.isBefore(_candidateRegStartDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Candidate registration end date must be after the start date.')),
      );
      return;
    }

    // Similar checks for other events
    if (_electionCampaignStartDate!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Election campaign start date cannot be in the past.')),
      );
      return;
    }
    if (_electionCampaignEndDate!.isBefore(_electionCampaignStartDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Election campaign end date must be after the start date.')),
      );
      return;
    }

    if (_voterRegStartDate!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voter registration start date cannot be in the past.')),
      );
      return;
    }
    if (_voterRegEndDate!.isBefore(_voterRegStartDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voter registration end date must be after the start date.')),
      );
      return;
    }

    if (_attentionStartDate!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attention time start date cannot be in the past.')),
      );
      return;
    }
    if (_attentionEndDate!.isBefore(_attentionStartDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attention time end date must be after the start date.')),
      );
      return;
    }

    if (_votingStartDate!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voting start date cannot be in the past.')),
      );
      return;
    }
    if (_votingEndDate!.isBefore(_votingStartDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voting end date must be after the start date.')),
      );
      return;
    }

    if (_resultAnnounceStartDate!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Result announcement start date cannot be in the past.')),
      );
      return;
    }
    if (_resultAnnounceEndDate!.isBefore(_resultAnnounceStartDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Result announcement end date must be after the start date.')),
      );
      return;
    }

    List<String> selectedConstituency = _selectedConstituencies.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    List<String> selectedParties = _selectedParties.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    String generateCustomId() {
      final random = Random();
      const chars = '0123456789';
      return List.generate(3, (index) => chars[random.nextInt(chars.length)]).join();
    }

    String uniqueId ="Elec"+ generateCustomId();

    // Store data in database or API
    final response = await http.post(
      Uri.parse('${loginPage.apiUrl}addelection'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'electionId': uniqueId,
        'electionName': electionName,
        'constituencies': selectedConstituency,
        'politicalParties': selectedParties,
        'schedules': {
          'candidateReg': {
            'startDate': _candidateRegStartDate?.toIso8601String(),
            'endDate': _candidateRegEndDate?.toIso8601String(),
          },
          'electionCampaign': {
            'startDate': _electionCampaignStartDate?.toIso8601String(),
            'endDate': _electionCampaignEndDate?.toIso8601String(),
          },
          'voterReg': {
            'startDate': _voterRegStartDate?.toIso8601String(),
            'endDate': _voterRegEndDate?.toIso8601String(),
          },
          'attentionTime': {
            'startDate': _attentionStartDate?.toIso8601String(),
            'endDate': _attentionEndDate?.toIso8601String(),
          },
          'voting': {
            'startDate': _votingStartDate?.toIso8601String(),
            'endDate': _votingEndDate?.toIso8601String(),
          },
          'resultAnnouncement': {
            'startDate': _resultAnnounceStartDate?.toIso8601String(),
            'endDate': _resultAnnounceEndDate?.toIso8601String(),
          },
        },
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Election added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add election')),
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submitElectionDetails();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // After selecting a date, also select time
      _selectTime(context, (time) {
        final DateTime selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        onDateSelected(selectedDateTime);
      });
    }
  }
  Future<void> _selectTime(BuildContext context, Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Election Input Flow'),
        backgroundColor: Color(0xff2193b0),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _prevStep,
        steps: [
          Step(
            title: Text('Election Details'),
            content: Column(
              children: [
                TextField(
                  controller: _electionNameController,
                  decoration: InputDecoration(labelText: 'Election Name'),
                ),
                Text('Select Constituencies:'),
                ..._constituencies.map((constituency) {
                  return CheckboxListTile(
                    title: Text(constituency),
                    value: _selectedConstituencies[constituency],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedConstituencies[constituency] = value!;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          Step(
            title: Text('Select Political Parties'),
            content: Column(
              children: [
                Text('Select Political Parties:'),
                ..._politicalParties.map((party) {
                  return CheckboxListTile(
                    title: Text(party),
                    value: _selectedParties[party],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedParties[party] = value!;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          Step(
            title: Text('Fill Schedule'),
            content: Column(
              children: [
                Text('Candidate Registration Dates:'),
                ListTile(
                  title: Text('Start Date & Time'),
                  subtitle: Text(_candidateRegStartDate != null ? _candidateRegStartDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _candidateRegStartDate = date;
                        _candidateRegError = null; // Clear error if valid
                      });
                    }),
                  ),
                ),
                if (_candidateRegError != null) Text(_candidateRegError!, style: TextStyle(color: Colors.red)),
                ListTile(
                  title: Text('End Date & Time'),
                  subtitle: Text(_candidateRegEndDate != null ? _candidateRegEndDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      if (_candidateRegStartDate != null && date.isBefore(_candidateRegStartDate!)) {
                        setState(() {
                          _candidateRegError = 'End date must be after start date.';
                        });
                      } else {
                        setState(() {
                          _candidateRegEndDate = date;
                          _candidateRegError = null; // Clear error if valid
                        });
                      }
                    }),
                  ),
                ),
                Divider(),
                Text('Election Campaign Dates:'),
                ListTile(
                  title: Text('Start Date & Time'),
                  subtitle: Text(_electionCampaignStartDate != null ? _electionCampaignStartDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _electionCampaignStartDate = date;
                      });
                    }),
                  ),
                ),
                ListTile(
                  title: Text('End Date & Time'),
                  subtitle: Text(_electionCampaignEndDate != null ? _electionCampaignEndDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _electionCampaignEndDate = date;
                      });
                    }),
                  ),
                ),
                Divider(),
                Text('Voter Registration Dates:'),
                ListTile(
                  title: Text('Start Date & Time'),
                  subtitle: Text(_voterRegStartDate != null ? _voterRegStartDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _voterRegStartDate = date;
                      });
                    }),
                  ),
                ),
                ListTile(
                  title: Text('End Date & Time'),
                  subtitle: Text(_voterRegEndDate != null ? _voterRegEndDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _voterRegEndDate = date;
                      });
                    }),
                  ),
                ),
                Divider(),
                Text('Attention Time Dates:'),
                ListTile(
                  title: Text('Start Date & Time'),
                  subtitle: Text(_attentionStartDate != null ? _attentionStartDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _attentionStartDate = date;
                      });
                    }),
                  ),
                ),
                ListTile(
                  title: Text('End Date & Time'),
                  subtitle: Text(_attentionEndDate != null ? _attentionEndDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _attentionEndDate = date;
                      });
                    }),
                  ),
                ),
                Divider(),
                Text('Voting Dates:'),
                ListTile(
                  title: Text('Start Date & Time'),
                  subtitle: Text(_votingStartDate != null ? _votingStartDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _votingStartDate = date;
                      });
                    }),
                  ),
                ),
                ListTile(
                  title: Text('End Date & Time'),
                  subtitle: Text(_votingEndDate != null ? _votingEndDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _votingEndDate = date;
                      });
                    }),
                  ),
                ),
                Divider(),
                Text('Result Announcement Dates:'),
                ListTile(
                  title: Text('Start Date & Time'),
                  subtitle: Text(_resultAnnounceStartDate != null ? _resultAnnounceStartDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _resultAnnounceStartDate = date;
                      });
                    }),
                  ),
                ),
                ListTile(
                  title: Text('End Date & Time'),
                  subtitle: Text(_resultAnnounceEndDate != null ? _resultAnnounceEndDate!.toLocal().toString() : 'Select date & time'),
                  trailing: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, (date) {
                      setState(() {
                        _resultAnnounceEndDate = date;
                      });
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextStep,
        tooltip: 'Next',
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}