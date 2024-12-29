import 'dart:ui';

class PoliticalParty {
  final String name;
  final String email;
  final String? ima;

  PoliticalParty({required this.name, required this.email, required this.ima});

  factory PoliticalParty.fromJson(Map<String, dynamic> json) {
    return PoliticalParty(
      name: json['name'],
      email: json['email'],
      ima: json['img'] != null ? json['img']['data'] : null, // Adjust based on your API response

    );
  }
}