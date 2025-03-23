import 'dart:convert';

import 'package:e_voting/models/announcement.dart';

import 'package:flutter/material.dart';
// Import the Announcement class

class viewannouncement extends StatelessWidget {
  final Announcement announcement;

  viewannouncement({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement Details'),
        backgroundColor: Color(0xff2193b0),
      ),
      body: SingleChildScrollView(
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
                itemCount: announcement.images.length,
                itemBuilder: (context, imgIndex) {
                  final image = announcement.images[imgIndex];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: image.data.isNotEmpty
                          ? DecorationImage(
                        image: MemoryImage(base64Decode(image.data)),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: image.data.isNotEmpty
                        ? null
                        : Center(child: Text('No image available')),
                  );
                },
              ),
              SizedBox(height: 10),
              Text(
                announcement.announcementt,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Posted on: ${DateTime.now().toString()}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
