import 'dart:async'; // Import Timer
import 'dart:convert';
import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/political_party/political_party_nav_bar.dart';
import 'package:e_voting/pages/voter/voter_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class uuserScheduleList extends StatefulWidget {
  const uuserScheduleList({super.key});

  @override
  State<uuserScheduleList> createState() => _ScheduleListState();
}

class Schedule {
  final String scheduleid;
  final String title;
  final DateTime started_date;
  final DateTime ended_date;
  final String status;
  final String description;

  Schedule({
    required this.scheduleid,
    required this.title,
    required this.started_date,
    required this.ended_date,
    required this.status,
    required this.description,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleid: json['scheduleid'],
      title: json['title'],
      started_date: DateTime.parse(json['started_date']),
      ended_date: DateTime.parse(json['ended_date']),
      status: json['status'],
      description: json['description'],
    );
  }
}

class _ScheduleListState extends State<uuserScheduleList> {
  List<Schedule> schedules = [];
  Timer? _timer; // Timer for counting down
  Map<String, Duration> _remainingDurations = {}; // Store remaining durations

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final Set<String> _sentNotifications = {};

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    _initializeNotifications(); // Initialize notifications
    fetchSchedules();
    _startTimer(); // Start the timer
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
      status = await Permission.notification.status; // Check status again
    }
    print("Notification permission status: $status"); // Log the status
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/icoon'); // Replace with your icon resource

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create a notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'ab',
      'your_channel_name',
      description: 'Your channel description',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  Future<void> _deleteschedule(String scheduleid) async {
    try {
      final response = await http.delete(Uri.parse('${loginPage.apiUrl}schedule/delete/${scheduleid}'));

      if (response.statusCode == 200) {
        setState(() {
          schedules.removeWhere((schedule) => schedule.scheduleid == scheduleid);
        });
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "You have successfully deleted the schedule.",
        );

        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);
      } else {
        throw Exception('Failed to delete schedule');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting schedule: $e')),
      );
    }
  }

  Future<void> fetchSchedules() async {
    final response = await http.get(Uri.parse('${loginPage.apiUrl}schedules'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        schedules = jsonData.map((json) => Schedule.fromJson(json)).toList();
        // Initialize remaining durations
        _remainingDurations = {
          for (var schedule in schedules)
            schedule.scheduleid: schedule.ended_date.difference(DateTime.now()),
        };
      });
    } else {
      print('Failed to load schedules');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        for (var schedule in schedules) {
          final remainingTime = schedule.ended_date.difference(DateTime.now());
          _remainingDurations[schedule.scheduleid] = remainingTime;

          // Check for notification conditions
          if (remainingTime.isNegative && !_sentNotifications.contains(schedule.scheduleid)) {
            _sendNotification("Time has passed for ${schedule.title}");
            _sentNotifications.add(schedule.scheduleid); // Mark as sent
            _remainingDurations.remove(schedule.scheduleid);
          } else if (remainingTime.inDays == 1 && remainingTime.inHours == 0) {
            _sendNotification("1 day left for ${schedule.title}");
          } else if (remainingTime.inHours == 1 && remainingTime.inDays == 0) {
            _sendNotification("1 hour left for ${schedule.title}");
          }
        }
      });
    });
  }

  Future<void> _sendNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'ab',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        'Schedule Alert', // Ensure this is not null
        message, // Ensure this is not null
        platformChannelSpecifics,
        payload: 'item x',
      );
    } catch (e) {
      print("Error sending notification: $e"); // Log any errors
    }
  }

  Text calculateRemainingTime(String scheduleId) {
    final remainingDuration = _remainingDurations[scheduleId];
    if (remainingDuration == null || remainingDuration.isNegative) {
      return Text(
        'Time has passed',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    }

    final years = remainingDuration.inDays ~/ 365;
    final months = (remainingDuration.inDays % 365) ~/ 30;
    final days = (remainingDuration.inDays % 365) % 30;
    final hours = remainingDuration.inHours % 24;
    final minutes = remainingDuration.inMinutes % 60;
    final seconds = remainingDuration.inSeconds % 60;

    return Text(
      '${years}y ${months}m ${days}d ${hours}h ${minutes}m ${seconds}s',
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: voterNavbarss(),
      body: SingleChildScrollView( // Wrap the entire body in a scrollable view
        child: Column(
          children: schedules.map((schedule) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule Title: ${schedule.title}\n'
                            'Started Date: ${schedule.started_date}\n'
                            'Ended Date: ${schedule.ended_date}\n'
                            'Status: ${schedule.status}\n'
                            'Description: ${schedule.description}\n',
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Text('Remaining Time: '),
                          calculateRemainingTime(schedule.scheduleid),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}