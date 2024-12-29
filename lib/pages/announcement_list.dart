import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_voting/pages/announcements.dart';
import 'package:e_voting/pages/announcment_view.dart';
import 'package:e_voting/pages/nav_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:e_voting/pages/loginpage.dart';

class announcementlist extends StatefulWidget {
  const announcementlist({super.key});

  @override
  State<announcementlist> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<announcementlist> {
  List<Map<String, dynamic>> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    try {
      final response = await http.get(Uri.parse('${loginPage.apiUrl}announcements'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          announcements = data.map((announcement) {
            return {
              "text": announcement['announcement'] ?? '',
              "images": List<String>.from(announcement['images'] ?? []), // This should be base64 strings
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load announcements');
      }
    } catch (error) {
      print("Error fetching announcements: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcements"),
        backgroundColor: Color(0xff2193b0),
      ),
      drawer: Navbarss(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 10, bottom: 20),
          child: Column(
            children: announcements.map((announcement) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewannouncement()));
                },
                child: AnnouncementContainer(
                  text: announcement['text'],
                  images: List<String>.from(announcement['images']),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => announcments()));
        },
        child: Container(
          height: 50,
          width: 100,
          child: FloatingActionButton(
            tooltip: 'Add Post',
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => announcments()));
            },
            child: Text(
              "Add Post",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class AnnouncementContainer extends StatelessWidget {
  final List<String> images; // List of base64 strings
  final String text; // Announcement text

  const AnnouncementContainer({required this.images, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: const Offset(4.0, 4.0),
            blurRadius: 15,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display images in rows
          if (images.isNotEmpty)
            Column(
              children: List.generate((images.length / 2).ceil(), (rowIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // First image in the row
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, bottom: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.memory(
                            base64Decode(images[rowIndex * 2]), // Decode base64 image
                            fit: BoxFit.cover,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                    // Second image in the row, if it exists
                    if (rowIndex * 2 + 1 < images.length)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.memory(
                              base64Decode(images[rowIndex * 2 + 1]), // Decode second image
                              fit: BoxFit.cover,
                              height: 150,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          SizedBox(height: 10),
          ReadMoreText(
            text,
            style: TextStyle(fontSize: 16),
            moreStyle: TextStyle(color: Colors.blue, fontSize: 18),
            lessStyle: TextStyle(color: Colors.blue, fontSize: 18),
          ),
          Divider(),
        ],
      ),
    );
  }
}