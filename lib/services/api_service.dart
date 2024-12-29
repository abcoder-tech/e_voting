import 'dart:convert';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/political_party_view.dart';
import 'package:http/http.dart' as http;
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



Future<int> fetchUserCount() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}/countUsers'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['count'];
  } else {
    throw Exception('Failed to load user count');
  }
}