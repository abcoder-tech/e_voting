import 'dart:convert';

import 'package:e_voting/models/Constituency.dart';
import 'package:e_voting/models/announcement_model.dart';
import 'package:e_voting/models/candidate.dart';
import 'package:e_voting/models/poling_station.dart';
import 'package:e_voting/pages/loginpage.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/political_party.dart';



Future<List<PoliticalParty>> fetchPoliticalParties() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}politicalparties'));
print("aaaa");
  if (response.statusCode == 200) {
    print("bbb");
    final List<dynamic> jsonData = json.decode(response.body)['data'];
    return jsonData.map((party) => PoliticalParty.fromJson(party)).toList();
  } else {
    throw Exception('Failed too load political parties');
  }
}


Future<List<candidate>> fetchcandidate() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}candidates'));
  print("aaaa");
  if (response.statusCode == 200) {
    print("6pppppppppppppppppppppppppppp");
    final List<dynamic> jsonData = json.decode(response.body)['data'];
    print(response.body); // Log the full response to debug
    return jsonData.map((candidatee) => candidate.fromJson(candidatee)).toList();
  } else {
    throw Exception('Failed too load candidates');
  }
}













Future<List<candidate>> fetchcandidate1(String ID) async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}candidatess/${ID}'));
  print("aaaa");
  if (response.statusCode == 200) {
    print("6pppppppppppppppppppppppppppp");
    final List<dynamic> jsonData = json.decode(response.body)['data'];
    print(response.body); // Log the full response to debug
    return jsonData.map((candidatee) => candidate.fromJson(candidatee)).toList();
  } else {
    throw Exception('Failed too load candidates');
  }
}










Future<List<candidate>> fetchcandidate2(String politicalparty) async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}candidatesss/${politicalparty}'));
  print("aaaa");
  if (response.statusCode == 200) {
    print("6pppppppppppppppppppppppppppp");
    final List<dynamic> jsonData = json.decode(response.body)['data'];
    print(response.body); // Log the full response to debug
    return jsonData.map((candidatee) => candidate.fromJson(candidatee)).toList();
  } else {
    throw Exception('Failed too load candidates');
  }
}











Future<List<Constituency>> fetchConstituencies() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}Constituency'));
  print("aaaa");
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((json) => Constituency.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load constituencies');
  }
}





Future<List<pollingstation>> fetchpollingstation() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}pollingstation'));
  print("aaaa");
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((json) => pollingstation.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load polling station');
  }
}








Future<List<announc>> fetchannouncement() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}announcements'));
  print("aaaa");
  if (response.statusCode == 200) {
    print("bbb");
    final List<dynamic> jsonData = json.decode(response.body)['data'];
    return jsonData.map((party) => announc.fromJson(party)).toList();
  } else {
    throw Exception('Failed too load announcement');
  }
}



Future<bool> deletePoliticalParty(String email) async {
  final response = await http.delete(
    Uri.parse('${loginPage.apiUrl}political_party/delete?email=$email'),
  );

  if (response.statusCode == 200) {
    return true; // Deletion was successful
  } else {
    throw Exception('Failed to delete party');
  }
}





Future<bool> deleteConstituency(String email) async {
  final response = await http.delete(
    Uri.parse('${loginPage.apiUrl}Constituency/delete?email=$email'),
  );

  if (response.statusCode == 200) {
    return true; // Deletion was successful
  } else {
    throw Exception('Failed to delete Constituency');
  }
}

Future<bool> deleteschedule(String scheduleid) async {
  final response = await http.delete(
    Uri.parse('${loginPage.apiUrl}schedule/delete?email=$scheduleid'),
  );

  if (response.statusCode == 200) {
    return true; // Deletion was successful
  } else {
    throw Exception('Failed to delete scheddule');
  }
}



Future<bool> deletenews(String pid) async {
  final response = await http.delete(
    Uri.parse('${loginPage.apiUrl}news/delete?pid=$pid'),
  );

  if (response.statusCode == 200) {
    return true; // Deletion was successful
  } else {
    throw Exception('Failed to delete news');
  }
}




Future<bool> updatePoliticalParty(String email, String name, XFile? image) async {
  var request = http.MultipartRequest('PUT', Uri.parse('${loginPage.apiUrl}political_party/update?email=${Uri.encodeQueryComponent(email)}&name=${Uri.encodeQueryComponent(name)}'));

  if (image != null) {
    request.files.add(await http.MultipartFile.fromPath('img', image.path));
  }

  final response = await request.send();

  if (response.statusCode == 200) {
    return true; // Update was successful
  } else {
    print('Failed with status: ${response.statusCode}');
    throw Exception('Failed to update party');
  }
}



Future<int> fetchUserCount() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}/countUsers'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['count'];
  } else {
    throw Exception('Failed to load user count');
  }
}