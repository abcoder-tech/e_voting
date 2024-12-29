import 'package:flutter/material.dart';

class addschedule extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<addschedule> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  Future<void> _selectStartDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _startDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectEndDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _endDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Schedule Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Start Date & Time',
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectStartDateTime(context),
              controller: TextEditingController(
                  text: _startDateTime != null
                      ? "${_startDateTime!.toLocal()}"
                      : ''),
            ),
            SizedBox(height: 16.0),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'End Date & Time',
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectEndDateTime(context),
              controller: TextEditingController(
                  text: _endDateTime != null
                      ? "${_endDateTime!.toLocal()}"
                      : ''),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle form submission logic here
                print('Title: ${_titleController.text}');
                print('Start Date & Time: $_startDateTime');
                print('End Date & Time: $_endDateTime');
                print('Description: ${_descriptionController.text}');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}