import 'dart:ui';

class pollingstation {
  final String name;
  final String email;

  final String description;
  final String constituencies_name;
  final String wereda;
  final String kebele;

  pollingstation({required this.name, required this.email, required this.description, required this.constituencies_name, required this.wereda, required this.kebele});

  factory pollingstation.fromJson(Map<String, dynamic> json) {
    return pollingstation(
      name: json['name'],
      email: json['email'],

      description: json['description'],
      constituencies_name: json['constituencies_name'],
  wereda: json['wereda'],
  kebele: json['kebele'],
      // Adjust based on your API response

    );
  }
}