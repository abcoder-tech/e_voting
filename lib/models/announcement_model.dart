import 'dart:ui';

class announc {
  final String announcemnt;
  final String pdate;
  final String pid;
  final String? ima;

  announc({required this.announcemnt, required this.pdate, required this.ima, required this.pid});

  factory announc.fromJson(Map<String, dynamic> json) {
    return announc(
      announcemnt: json['announcement'],
      pid: json['pid'],
      pdate: json['pdate'],
      ima: json['images'] != null ? json['images']['data'] : null, // Adjust based on your API response

    );
  }
}