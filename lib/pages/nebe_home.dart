import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NebeHome extends StatefulWidget {
  const NebeHome({super.key});

  @override
  State<NebeHome> createState() => _NebeHomeState();
}

class _NebeHomeState extends State<NebeHome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Initialize animations for each container
    _animations = List.generate(5, (index) {
      return Tween<double>(begin: -100, end: 0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2, // Stagger the start times
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    // Start the animation
    Future.delayed(const Duration(milliseconds: 100), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double baseRadius = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Color(0xff2193b0),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff2193b0),
                ),
                height: screenHeight * 0.1,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/images/nebe banner.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // Adjust the fraction as needed,
              Expanded(
                child: Container(

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(baseRadius * 6.5),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
                      child: Column(
                        children: [
                          _buildAnimatedContainer("6571 Voters", 'lib/images/voter.jpg', screenHeight, screenWidth, baseRadius, 0),
                          SizedBox(height: screenHeight * 0.02),
                          _buildAnimatedContainer("105 Political Parties", 'lib/images/political party.jpg', screenHeight, screenWidth, baseRadius, 1),
                          SizedBox(height: screenHeight * 0.02),
                          _buildAnimatedContainer("105 Polling Stations", 'lib/images/poling sation.webp', screenHeight, screenWidth, baseRadius, 2),
                          SizedBox(height: screenHeight * 0.02),
                          _buildAnimatedContainer("105 Regions", 'lib/images/region.webp', screenHeight, screenWidth, baseRadius, 3),
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

  Widget _buildAnimatedContainer(String title, String imagePath, double screenHeight, double screenWidth, double baseRadius, int index) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, -1), // Start above the screen
        end: Offset(0, 0), // End at original position
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(index * 0.2, 1.0, curve: Curves.easeOut),
      )),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(baseRadius)),
            color: Colors.grey,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          height: screenHeight * 0.25,
          width: screenWidth * 0.85,
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.21),
            child: Container(
              color: Color(0xff2193b0),
              width: screenWidth * 0.85,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
