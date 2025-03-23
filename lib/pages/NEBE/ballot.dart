import 'package:flutter/material.dart';

void main() {
  runApp(VotingPollApp());
}

class VotingPollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting Poll',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VotingPollHome(),
    );
  }
}

class VotingPollHome extends StatefulWidget {
  @override
  _VotingPollHomeState createState() => _VotingPollHomeState();
}

class _VotingPollHomeState extends State<VotingPollHome> {
  final List<String> options = [
    "Option 1",
    "Option 2",
    "Option 3",
    "Option 4",
  ];
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: options.map((option) {
                  return CheckboxListTile(
                    title: Text(option),
                    value: selectedOptions.contains(option),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedOptions.add(option);
                        } else {
                          selectedOptions.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedOptions.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VotingPage(selectedOptions: selectedOptions),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select at least one option')),
                  );
                }
              },
              child: Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}

class VotingPage extends StatefulWidget {
  final List<String> selectedOptions;

  VotingPage({required this.selectedOptions});

  @override
  _VotingPageState createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  String? selectedPollOption;
  Map<String, int> voteCounts = {};

  @override
  void initState() {
    super.initState();
    // Initialize vote counts for each selected option
    for (var option in widget.selectedOptions) {
      voteCounts[option] = 0;
    }
  }

  void vote() {
    if (selectedPollOption != null) {
      setState(() {
        voteCounts[selectedPollOption!] = voteCounts[selectedPollOption!]! + 1;
        // Optionally clear the selection after voting
        selectedPollOption = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vote counted for $selectedPollOption!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vote for Your Favorite'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...widget.selectedOptions.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedPollOption,
                onChanged: (String? value) {
                  setState(() {
                    selectedPollOption = value;
                  });
                },
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: vote,
              child: Text('Vote'),
            ),
            SizedBox(height: 20),
            Text('Vote Counts:', style: TextStyle(fontSize: 20)),
            ...widget.selectedOptions.map((option) {
              return Text('$option: ${voteCounts[option]} votes');
            }).toList(),
          ],
        ),
      ),
    );
  }
}