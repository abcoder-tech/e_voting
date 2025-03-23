import 'dart:ui';

class candidate {
  final String candidateid;
  final String
  candidatesname;
  final String educationlevel;
  final String politicalparty;
  final String constituency;
  final String? ima;

  candidate({ required this.candidateid,  required this.
  candidatesname, required this.educationlevel,required this.politicalparty, required this.constituency, required this.ima});

  factory candidate.fromJson(Map<String, dynamic> json) {
    return candidate(
      candidateid: json['candidateid'],
      candidatesname: json['candidatename'],
      educationlevel: json['educationlevel'],
      politicalparty: json['politicalparty'],
      constituency: json['constituency'],
      ima: json['img'] != null ? json['img']['data'] : null, // Adjust based on your API response

    );
  }
}