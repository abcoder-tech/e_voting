import 'dart:convert';



import 'package:e_voting/pages/voter/political_party_list.dart';
import 'package:e_voting/pages/voter/voter_campaign_list.dart';
import 'package:e_voting/pages/voter/voter_candidate.dart';
import 'package:e_voting/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';


class viewparty extends StatefulWidget {
  final String email;
  final String name;
  final String? img;
  const viewparty({super.key, required this.email, required this.name, this.img});

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
        QuickAlert.show(
          context:context,
          type:QuickAlertType.success,
          text:"you succesfully delete party",
        );

        await Future.delayed(Duration(seconds: 1));
        Navigator.push(context, MaterialPageRoute(builder: (context) => PoliticalPartyList())); // Navigate back to the previous screen
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting partyy: $e')),
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
                        padding: const EdgeInsets.only(left:60, top: 10),
                        child: Center(
                          child: Text(
                            "${widget.name} Party",
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
                            Container(

                              height: 180,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                  image: widget.img != null ? MemoryImage(base64Decode(widget.img!)) : AssetImage('lib/images/default.jpg'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),// Row for first two images
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("  Party Activities",style: TextStyle(
                                    fontSize: 16
                                ),),
                                Divider(),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => candidatesLists(name: widget.name)));
                                  },
                                  child: Container(

                                    height: 70,
                                    // width: 300,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      boxShadow: [

                                      ],
                                    ),
                                    child: Center(
                                      child: Text("Candidates",style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: 20,color: Colors.green),),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => nebecampaignList(name: widget.name)));

                                  },
                                  child: Container(

                                    height: 70,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(Radius.circular(15)),

                                    ),
                                    child: Center(
                                      child: Text("Campaigns",style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: 20,color: Colors.green),),
                                    ),
                                  ),
                                ),// Space between images

                                SizedBox(height: 10), // Space below the first row of images
                                // Row for third image

                                SizedBox(height: 10), // Space below the third image

                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
              ) ],
          ),
        ),
      ),

    );
  }
}
