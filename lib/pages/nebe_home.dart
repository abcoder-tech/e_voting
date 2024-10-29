import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NebeHome extends StatefulWidget {
  const NebeHome({super.key});

  @override
  State<NebeHome> createState() => _NebeHomeState();
}

class _NebeHomeState extends State<NebeHome> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Define a base radius for responsiveness
    final double baseRadius = screenWidth * 0.05; // 5% of the screen width

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Color(0xff2193b0),
                ),
                height: screenHeight * 0.1, // Responsive height
                width: double.infinity, // Full width
                child: Text(
                  "Trusted For Your Vote",
                  style: TextStyle(
                    fontSize: screenWidth * 0.07, // Responsive font size
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0), // Keep top right square
                      topLeft: Radius.circular(baseRadius * 1.5), // Make top left curved
                      bottomLeft: Radius.circular(0), // Keep bottom left square
                      bottomRight: Radius.circular(0), // Keep bottom right square
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(baseRadius)), // Responsive radius
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: AssetImage('lib/images/1.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: screenHeight * 0.25, // Responsive height
                              width: screenWidth * 0.85, // Responsive width
                              child: Padding(
                                padding: EdgeInsets.only(top: screenHeight * 0.21, left: screenWidth * 0.19),
                                child: Text(
                                  "6571 Voters",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.06, // Responsive font size
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02), // Responsive spacing
                          // Repeat the container for other items
                          for (int i = 0; i < 3; i++)
                            Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.02), // Responsive spacing
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(baseRadius)), // Responsive radius
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: AssetImage('lib/images/1.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: screenHeight * 0.25, // Responsive height
                                  width: screenWidth * 0.85,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: screenHeight * 0.21, left: screenWidth * 0.19),
                                    child: Text(
                                      "6571 Voters",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.06, // Responsive font size
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),// Responsive width
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}