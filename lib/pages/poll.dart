import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PollPage extends StatefulWidget {
  @override
  _PollPageState createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  String? _selectedOption;
  final List<String> _options = [
    'Option A',
    'Option B',
    'Option C',
    'Option D',
  ];

  final Map<String, int> _votes = {
    'Option A': 0,
    'Option B': 0,
    'Option C': 0,
    'Option D': 0,
  };

  void _submitVote() {
    if (_selectedOption != null) {
      setState(() {
        _votes[_selectedOption!] = _votes[_selectedOption!]! + 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You voted for $_selectedOption')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an option')),
      );
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Poll Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _votes.entries.map((entry) {
              return Text('${entry.key}: ${entry.value} votes');
            }).toList(),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vote for Your Option')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._options.map((option) => RadioListTile<String>(
              title: Text(
                option,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Custom text style
              ),
              value: option,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
              activeColor: Colors.blueAccent, // Change the active color
              tileColor: _selectedOption == option ? Colors.lightBlueAccent.withOpacity(0.3) : null, // Change background color when selected
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitVote,
              child: Text('Submit Vote'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showResults,
              child: Text('Show Results'),
            ),
          ],
        ),
      ),
    );
  }
}