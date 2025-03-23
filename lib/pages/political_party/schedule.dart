import 'dart:async';
import 'dart:convert';
import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class ScheduleList extends StatefulWidget {
  final String electionId;
  const ScheduleList({super.key, required this.electionId});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

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

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleid: json['_id'],
      electionId: json['electionId'],
      electionName: json['electionName'],
      candidateRegStartDate: DateTime.parse(json['schedules']['candidateReg']['startDate']),
      candidateRegEndDate: DateTime.parse(json['schedules']['candidateReg']['endDate']),
      electionCampaignStartDate: DateTime.parse(json['schedules']['electionCampaign']['startDate']),
      electionCampaignEndDate: DateTime.parse(json['schedules']['electionCampaign']['endDate']),
      voterRegStartDate: DateTime.parse(json['schedules']['voterReg']['startDate']),
      voterRegEndDate: DateTime.parse(json['schedules']['voterReg']['endDate']),
      attentionTimeStartDate: DateTime.parse(json['schedules']['attentionTime']['startDate']),
      attentionTimeEndDate: DateTime.parse(json['schedules']['attentionTime']['endDate']),
      votingStartDate: DateTime.parse(json['schedules']['voting']['startDate']),
      votingEndDate: DateTime.parse(json['schedules']['voting']['endDate']),
      resultAnnouncementStartDate: DateTime.parse(json['schedules']['resultAnnouncement']['startDate']),
      resultAnnouncementEndDate: DateTime.parse(json['schedules']['resultAnnouncement']['endDate']),
    );
  }
}

class _ScheduleListState extends State<ScheduleList> {
  List<Schedule> schedules = [];
  String? expandedScheduleId;
  Timer? _timer;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final Set<String> _sentNotifications = {};

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    _initializeNotifications();
    fetchSchedules();
    _startTimer();
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
      status = await Permission.notification.status;
    }
    print("Notification permission status: $status");
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/icoon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'ab',
      'your_channel_name',
      description: 'Your channel description',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchSchedules() async {
    final response = await http.get(Uri.parse('${loginPage.apiUrl}elections/${widget.electionId}'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

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
  }

  void toggleSchedule(String scheduleId) {
    setState(() {
      if (expandedScheduleId == scheduleId) {
        expandedScheduleId = null;
      } else {
        expandedScheduleId = scheduleId;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        for (var schedule in schedules) {
          final remainingTime = schedule.votingEndDate.difference(DateTime.now());

          if (remainingTime.isNegative && !_sentNotifications.contains(schedule.scheduleid)) {
            _sendNotification("Time has passed for ${schedule.electionName}");
            _sentNotifications.add(schedule.scheduleid);
          } else if (remainingTime.inDays == 1 && remainingTime.inHours == 0) {
            _sendNotification("1 day left for ${schedule.electionName}");
          } else if (remainingTime.inHours == 1 && remainingTime.inMinutes == 60 && remainingTime.inDays == 0) {
            _sendNotification("1 hour left for ${schedule.electionName}");
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
        0,
        'Schedule Alert',
        message,
        platformChannelSpecifics,
        payload: 'item x',
      );
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  String formatDuration(Duration duration) {
    if (duration.isNegative) return 'Time has passed';

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  Widget buildScheduleContainer(String title, DateTime startDate, DateTime endDate) {
    final DateTime now = DateTime.now();
    final bool isEventStarted = startDate.isBefore(now);
    final bool isEventended = endDate.isBefore(now);
    final Duration remainingToStart = startDate.difference(now);
    final Duration remainingToEnd = endDate.difference(now);

    String statusMessage;
    String remainingTime;

    if (!isEventStarted) {
      statusMessage = 'Event starts in:';
      remainingTime = formatDuration(remainingToStart);
    } else if(!isEventended){
      statusMessage = 'Event has started!';
      remainingTime = 'Remaining to end: ' + formatDuration(remainingToEnd);
    }
    else{
      statusMessage = 'Event has Ended!';
      remainingTime = 'Thank You!';
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Start Date: ${startDate}'),
          Text('End Date: ${endDate}'),
          SizedBox(height: 8),
          Text(statusMessage, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(remainingTime, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule"),
        backgroundColor: Color(0xff2193b0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: schedules.map((schedule) {
            return GestureDetector(
              onTap: () => toggleSchedule(schedule.scheduleid),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildScheduleContainer(

                      'Candidate Registration',
                      schedule.candidateRegStartDate,
                      schedule.candidateRegEndDate,
                    ),
                    buildScheduleContainer(
                      'Election Campaign',
                      schedule.electionCampaignStartDate,
                      schedule.electionCampaignEndDate,
                    ),
                    buildScheduleContainer(
                      'Voter Registration',
                      schedule.voterRegStartDate,
                      schedule.voterRegEndDate,
                    ),
                    buildScheduleContainer(
                      'Attention Time',
                      schedule.attentionTimeStartDate,
                      schedule.attentionTimeEndDate,
                    ),
                    buildScheduleContainer(
                      'Voting',
                      schedule.votingStartDate,
                      schedule.votingEndDate,
                    ),
                    buildScheduleContainer(
                      'Result Announcement',
                      schedule.resultAnnouncementStartDate,
                      schedule.resultAnnouncementEndDate,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}