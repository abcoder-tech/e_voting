import 'dart:ui';

class Constituency {
  final String ID;
  final String name;
  final String email;
  final String region;
  final String description;


  Constituency( { required this.ID,required this.name, required this.email, required this.region, required this.description});

  factory Constituency.fromJson(Map<String, dynamic> json) {
    return Constituency(
      name: json['name'],
      email: json['email'],
  region: json['region'],
  description: json['description'],
      ID: json['ID'],
       // Adjust based on your API response

    );
  }
}