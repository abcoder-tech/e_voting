import 'dart:io';
import 'dart:math';
import 'package:e_voting/pages/loginpage.dart';
import 'package:http/http.dart' as http;
import 'package:e_voting/components/mybotton.dart';
import 'package:e_voting/pages/announcement_list.dart';
import 'package:e_voting/pages/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class announcments extends StatefulWidget {
  const announcments({super.key});

  @override
  State<announcments> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<announcments> {
  List<File> _images = [];
  final TextEditingController _announcementController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _images.addAll(images.map((image) => File(image.path)).toList());
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _postAnnouncement() async {
    if (_announcementController.text.isEmpty || _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an announcement and select images.')),
      );
      return;
    }

    String generateCustomId() {
      final random = Random();
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      return List.generate(10, (index) => chars[random.nextInt(chars.length)]).join();
    }

    String uniqueId = generateCustomId();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${loginPage.apiUrl}addannouncement'),
    );

    request.fields['announcement'] = _announcementController.text;
    request.fields['pid'] = uniqueId; // Replace with actual pid

    for (File image in _images) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        image.path,
      ));
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Announcement posted successfully!')),
      );
      setState(() {
        _images.clear();
        _announcementController.clear();
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => announcementlist()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post announcement.')),
      );
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.file(
                      _images[index],
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeImage(index),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Add Photo From Gallery'),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _announcementController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                  isDense: true,
                  hintText: "Write an Announcement here",
                ),
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const SizedBox(height: 20),
            mybotton(
              onTap: _postAnnouncement,
              butttontext: 'Post Announcement',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}