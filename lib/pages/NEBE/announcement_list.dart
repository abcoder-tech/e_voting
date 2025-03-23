import 'dart:convert';
import 'dart:typed_data';

import 'package:e_voting/pages/NEBE/announcements.dart';
import 'package:e_voting/pages/NEBE/announcment_view.dart';
import 'package:e_voting/pages/NEBE/nav_bar.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_voting/models/announcement.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

// Fetch announcements from the server
Future<List<Announcement>> fetchAnnouncements() async {
  final response = await http.get(Uri.parse('${loginPage.apiUrl}announcements'));

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
    // Convert to base64 or appropriate format and add to imagesToUpdate
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    imagesToUpdate.add(ImageData(data: base64Image, contentType: 'image/jpeg')); // Adjust contentType accordingly
  }
}

// Call this method in the onPressed of the 'Add Image' button

// Delete announcement function
Future<void> _deletenews(BuildContext context, String pid) async {
  try {
    final response = await http.delete(Uri.parse('${loginPage.apiUrl}news/delete/$pid'));

    if (response.statusCode == 200) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "You have successfully deleted the announcement.",
      );
      await Future.delayed(Duration(seconds: 1));
      await Navigator.push(context, MaterialPageRoute(builder: (context)=>AnnouncementList()));


      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AnnouncementList()));
    } else {
      throw Exception('Failed to delete announcement');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting announcement: $e')),
    );
  }
}

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({super.key});

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  late Future<List<Announcement>> futureAnnouncements;
  String? expandedAnnouncementId; // Track which announcement is expanded

  @override
  void initState() {
    super.initState();
    futureAnnouncements = fetchAnnouncements();
  }

  void toggleAnnouncement(String announcementId) {
    setState(() {
      if (expandedAnnouncementId == announcementId) {
        expandedAnnouncementId = null; // Collapse if already expanded
      } else {
        expandedAnnouncementId = announcementId; // Expand the selected announcement
      }
    });
  }

  void showUpdateDialog(BuildContext context, Announcement announcement) {
    final TextEditingController announcementController = TextEditingController(text: announcement.announcementt);
    List<ImageData> imagesToUpdate = List.from(announcement.images); // Copy the current images

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Announcement'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: announcementController,
                  decoration: InputDecoration(labelText: 'Announcement Text'),
                ),
                SizedBox(height: 10),
                Text('Images:', style: TextStyle(fontWeight: FontWeight.bold)),
                // Display existing images
                Column(
                  children: imagesToUpdate.map((image) {
                    return Stack(
                      children: [
                        // Display the image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: MemoryImage(base64Decode(image.data)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                imagesToUpdate.remove(image); // Remove image from the list
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    pickImage(imagesToUpdate); // Call the image picker method
                  },
                  child: Text('Add Image'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Prepare data for update
                final updatedAnnouncement = Announcement(
                  id: announcement.id,
                  pdate: announcement.pdate,
                  announcementt: announcementController.text,
                  images: imagesToUpdate,
                );

                // Send update request to the server
                await updateAnnouncement(updatedAnnouncement);
                Navigator.pop(context); // Close the dialog
                setState(() {
                  futureAnnouncements = fetchAnnouncements(); // Refresh list
                });
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog on cancel
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateAnnouncement(Announcement announcement) async {
    final response = await http.put(
      Uri.parse('${loginPage.apiUrl}news/update/${announcement.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'announcement': announcement.announcementt,
        'images': announcement.images.map((img) => {
          'data': img.data,
          'contentType': img.contentType,
        }).toList(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update announcement');
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
              final isExpanded = expandedAnnouncementId == announcement.id; // Check if this announcement is expanded

              // Limit announcement text to 50 words
              String announcementText = announcement.announcementt;
              List<String> words = announcementText.split(' ');
              if (words.length > 50) {
                announcementText = words.take(50).join(' ') + '...';
              }

              return GestureDetector(
                onTap: () => toggleAnnouncement(announcement.id), // Toggle on tap
                child: Card(
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => viewannouncement(announcement: announcement)));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.white.withOpacity(0.6),
                          ),
                          child: Text('Show More'),
                        ),
                        Text(
                          'Posted on: ${DateTime.now().toString()}',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                        SizedBox(height: 10),
                        if (isExpanded) ...[ // Show buttons only if expanded
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showUpdateDialog(context, announcement); // Show update dialog
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8),
                                    Text('Update'),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.confirm,
                                    text: "Are you sure you want to delete this item?",
                                    confirmBtnText: "Yes",
                                    cancelBtnText: "Cancel",
                                    onConfirmBtnTap: () async {
                                      await _deletenews(context, announcement.id);
                                      Navigator.pop(context);
                                    },
                                    onCancelBtnTap: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Announcements()));
          },
          tooltip: 'Add Announcement',
          backgroundColor: Colors.green,
          child: Text("Add News", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}