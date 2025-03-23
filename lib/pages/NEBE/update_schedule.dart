import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_voting/pages/NEBE/schedule_list.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class UpdateSchedule extends StatefulWidget {
  final Schedule schedule; // Accept the Schedule object

  const UpdateSchedule({Key? key, required this.schedule}) : super(key: key);

  @override
  _UpdateScheduleState createState() => _UpdateScheduleState();
}

class _UpdateScheduleState extends State<UpdateSchedule> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  final _formKey = GlobalKey<FormState>();

  String _status = 'Active';

  @override
  void initState() {
    super.initState();
    // Pre-fill the form fields with existing schedule data
    _titleController.text = widget.schedule.title;
    _descriptionController.text = widget.schedule.description;
    _startDateTime = widget.schedule.started_date;
    _endDateTime = widget.schedule.ended_date;
    _status = widget.schedule.status; // Set initial status if needed
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<String> updateSchedule() async {
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

      final request = http.MultipartRequest(
        'PUT', // Change to PUT for updates
        Uri.parse("${loginPage.apiUrl}updateSchedule/${widget.schedule.scheduleid}"), // Use the schedule ID
      );

      request.fields['title'] = _titleController.text;
      request.fields['started_date'] = _startDateTime!.toIso8601String();
      request.fields['ended_date'] = _endDateTime!.toIso8601String();
      request.fields['status'] = _status.isNotEmpty ? _status : 'default_status';
      request.fields['description'] = _descriptionController.text;

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "You successfully updated the schedule.",
          );

          await Future.delayed(Duration(seconds: 1));
          Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleList()));
          return 'Schedule updated successfully'; // Return success message
        } else {
          final responseBody = await http.Response.fromStream(response);
          final Map<String, dynamic> responseData = json.decode(responseBody.body);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: responseData['message'] ?? 'Failed to update schedule.',
          );

          await Future.delayed(Duration(seconds: 2));
          return 'Failed to update schedule'; // Return failure message
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
      initialDate: _startDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startDateTime ?? DateTime.now()),
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
      initialDate: _endDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endDateTime ?? DateTime.now()),
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
        title: Text('Update Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                  text: _startDateTime != null ? "${_startDateTime!.toLocal()}" : '',
                ),
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
                  text: _endDateTime != null ? "${_endDateTime!.toLocal()}" : '',
                ),
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
                onPressed: updateSchedule,
                child: Text('Update Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}