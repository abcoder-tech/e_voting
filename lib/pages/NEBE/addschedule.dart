import 'dart:convert';
import 'dart:math';



import 'package:e_voting/pages/NEBE/political_party_list.dart';
import 'package:e_voting/pages/NEBE/schedule_list.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class addschedule extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<addschedule> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  final _formKey = GlobalKey<FormState>();


  String _status = 'Active';





  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }



  Future<String> addschedule() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Check if start date is before end date
      if (_startDateTime != null && _endDateTime != null) {
        if (_startDateTime!.isAfter(_endDateTime!)) {

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Start date must be before end date.",
          );

          await Future.delayed(Duration(seconds: 2));
          return 'Invalid date range'; // Exit the function if dates are not valid
        }
      }

      print('Title: ${_titleController.text}');
      print('Started Date: ${_startDateTime?.toIso8601String()}');
      print('Ended Date: ${_endDateTime?.toIso8601String()}');
      print('Status: $_status');
      print('Description: ${_descriptionController.text}');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${loginPage.apiUrl}addschedule"),
      );

      String generateCustomId() {
        final random = Random();
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        return List.generate(10, (index) => chars[random.nextInt(chars.length)]).join();
      }

      String uniqueId = generateCustomId();

      request.fields['scheduleid'] = uniqueId;
      request.fields['title'] = _titleController.text;

      // Check if DateTime variables are not null
      request.fields['started_date'] = _startDateTime!.toIso8601String();
      request.fields['ended_date'] = _endDateTime!.toIso8601String();
      request.fields['status'] = _status.isNotEmpty ? _status : 'default_status';
      request.fields['description'] = _descriptionController.text;

      try {
        final response = await request.send();

        if (response.statusCode == 201) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "You successfully added a new schedule.",
          );

          await Future.delayed(Duration(seconds: 1));
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleList()));
          return 'Schedule added successfully'; // Return success message
        } else {
          final responseBody = await http.Response.fromStream(response);
          final Map<String, dynamic> responseData = json.decode(responseBody.body);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: responseData['message'] ?? 'Failed to add schedule.',
          );

          await Future.delayed(Duration(seconds: 2));
          return 'Failed to add schedule'; // Return failure message
        }
      } catch (error) {
        showError('An error occurred: $error');
        return 'An error occurred'; // Return error message
      }
    } else {
      showError('Please fill in all fields correctly.');
      return 'Form validation failed'; // Return message for form validation failure
    }
  }



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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                  onPressed:addschedule,
                  child: Text('Add Schedule'),
            
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}