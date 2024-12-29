import 'package:e_voting/pages/political_party_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_voting/services/api_service.dart';

class viewparty extends StatefulWidget {
  final String email;
  const viewparty({super.key, required this.email});

  @override
  State<viewparty> createState() => _viewpartyState();
}

class _viewpartyState extends State<viewparty> {
  //final ApiService _apiService = ApiService(); // Create an instance of your API service

  Future<void> _deleteParty() async {

    try {
      bool success = await deletePoliticalParty(widget.email);
      if (success) {
        // Notify the user and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Party deleted successfully')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => PoliticalPartyList())); // Navigate back to the previous screen
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting party: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff2193b0),
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Container(
          height: screenHeight,
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(80),
              topRight: Radius.circular(80),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PoliticalPartyList()));
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 40,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:80, top: 10),
                        child: Center(
                          child: Text(
                              "${widget.email} Party",
                            style: TextStyle(color: Colors.green, fontSize: 30,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),


                    ],
                  )
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row for first two images
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "lib/images/voter.jpg", // First image path
                                  height: 150, // Adjust heig ht as needed
                                  fit: BoxFit.cover, // Adjust fit as needed
                                ),
                              ),
                              SizedBox(width: 10), // Space between images
                              Expanded(
                                child: Image.asset(
                                  "lib/images/voter.jpg", // Second image path
                                  height: 150, // Adjust height as needed
                                  fit: BoxFit.cover, // Adjust fit as needed
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Space below the first row of images
                          // Row for third image
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "lib/images/voter.jpg", // Third image path
                                  height: 150, // Adjust height as needed
                                  fit: BoxFit.cover, // Adjust fit as needed
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Space below the third image

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 50,
            width: 100,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  PoliticalPartyList()));
              },
              tooltip: 'Update',
              backgroundColor: Colors.blue,
              child: Text(
                "Update",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 100,
            child: FloatingActionButton(
              onPressed:  _deleteParty,


              tooltip: 'Delete',
              backgroundColor: Colors.red,
              child: Text(
                "Delete",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
