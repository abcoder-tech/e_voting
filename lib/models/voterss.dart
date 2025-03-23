class Voter {
  final String voterId;
  final String voterName;
  final String pollingStation;
  final String constituency;
  final int age;
  final String sex;
  final String? ima; // Base64 string for the image or null if no image

  Voter({
    required this.voterId,
    required this.voterName,
    required this.pollingStation,
    required this.constituency,
    required this.age,
    required this.sex,
    this.ima,
  });

  // Factory method to create a Voter from JSON
  factory Voter.fromJson(Map<String, dynamic> json) {
    return Voter(
      voterId: json['voterId'] ?? '',
      voterName: json['voterName'] ?? '',
      pollingStation: json['pollingstation_name'] ?? '',
      constituency: json['constituencies_name'] ?? '',
      age: json['age'] ?? 0,
      sex: json['sex'] ?? '',
      ima: json['img'] != null && json['img']['data'] != null
          ? json['img']['data'] // Extract the base64 string
          : null,
    );
  }

  // Convert Voter to JSON
  Map<String, dynamic> toJson() {
    return {
      'voterId': voterId,
      'voterName': voterName,
      'pollingstation_name': pollingStation,
      'constituencies_name': constituency,
      'age': age,
      'sex': sex,
      'img': ima != null ? {'data': ima} : null, // Include image if it's not null
    };
  }
}