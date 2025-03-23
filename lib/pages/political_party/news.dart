import 'dart:convert';
import 'package:e_voting/pages/NEBE/announcment_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_voting/models/announcement.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/political_party/political_party_nav_bar.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

Future<List<Announcement>> fetchAnnouncements() async {
  // Here we are specifically fetching announcements for "Political Party"
  final response = await http.get(
      Uri.parse('${loginPage.apiUrl}aannouncements')
  );

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((data) => Announcement.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load announcements');
  }
}

class userAnnouncementList extends StatefulWidget {


  const userAnnouncementList({super.key, });

  @override
  State<userAnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<userAnnouncementList> {
  late Future<List<Announcement>> futureAnnouncements;

  @override
  void initState() {
    super.initState();
    futureAnnouncements = fetchAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcements"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: politicalpartyNavbarss(),
      body: FutureBuilder<List<Announcement>>(
        future: futureAnnouncements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No announcements found.'));
          }

          final announcements = snapshot.data!;

          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];

              String announcementText = announcement.announcementt;
              List<String> words = announcementText.split(' ');
              if (words.length > 50) {
                announcementText = words.take(50).join(' ') + '...';
              }

              String formattedDate = "${announcement.pdate.hour}:${announcement.pdate.minute} ${announcement.pdate.day}/${announcement.pdate.month}/${announcement.pdate.year} ";

              return GestureDetector(
                onTap: () {
                  // Navigate to announcement view when tapped
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewannouncement(announcement: announcement)));
                },
                child: Column(
                  children: [
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: announcement.images.length > 2 ? 2 : announcement.images.length,
                              itemBuilder: (context, imgIndex) {
                                final image = announcement.images[imgIndex];
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: FadeInImage(
                                    placeholder: AssetImage('lib/images/loading.jpg'),
                                    image: MemoryImage(base64Decode(image.data)),
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Center(child: Text('No image available'));
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              announcementText,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Posted on:  $formattedDate',
                              style: TextStyle(fontSize: 14, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}