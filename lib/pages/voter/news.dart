import 'dart:convert';

import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/voter/view_news.dart';
import 'package:e_voting/pages/voter/voter_nav_bar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_voting/models/announcement.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

// Fetch announcements from the server
Future<List<Announcement>> fetchAnnouncements() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}vannouncements'));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((data) => Announcement.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load announcements');
  }
}

// Add this method to handle image selection
Future<void> pickImage(List<ImageData> imagesToUpdate) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    imagesToUpdate.add(ImageData(data: base64Image, contentType: 'image/jpeg'));
  }
}

// Delete announcement function


class uuserAnnouncementList extends StatefulWidget {
  const uuserAnnouncementList({super.key});

  @override
  State<uuserAnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<uuserAnnouncementList> {
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
      drawer: voterNavbarss(),
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

              // Limit announcement text to 50 words
              String announcementText = announcement.announcementt;
              List<String> words = announcementText.split(' ');
              if (words.length > 50) {
                announcementText = words.take(50).join(' ') + '...';
              }

              // Format the posted date
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
                            // Display images in grid
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