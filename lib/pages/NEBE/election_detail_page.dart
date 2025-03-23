import 'package:e_voting/pages/NEBE/polling_station_view.dart';
import 'package:e_voting/pages/NEBE/schedule_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ElectionDetailPage extends StatelessWidget {
  final String electionName;
  final String electionId;
  final List<String> politicalParties;
  final List<String> constituencies;
  final Map<String, dynamic> schedules;

  const ElectionDetailPage({
    Key? key,
    required this.electionName,
    required this.electionId,
    required this.politicalParties,
    required this.constituencies,
    required this.schedules,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Election Detail"),
        backgroundColor: Color(0xff2193b0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
                width: 420,

                decoration: BoxDecoration(
                  color: CupertinoColors.activeGreen,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),)
                ),
                child: Center(child: Text('$electionName', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)))),
            SizedBox(height: 10),
            Text('Election ID: $electionId', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Political Parties: ${politicalParties.join(", ")}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Constituencies: ${constituencies.join(", ")}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 180),
           // Text('Schedules:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleList(electionId: electionId)));
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
                  child: Text("Schedules",style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 20,color: Colors.green),),
                ),
              ),
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BallotPage(electionId: electionId)));
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
                  child: Text("Voting Poll",style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 20,color: Colors.green),),
                ),
              ),
            ),
    ]
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
             // Navigator.push(context, MaterialPageRoute(builder: (context)=>ElectionInputFlow()));
              // Show the add campaign dialog
            },
            tooltip: 'Add election',
            backgroundColor: Colors.blue,
            child: Text("Update",style: TextStyle(fontSize: 18)),
          ),
              ),

          Container(
            height: 50,
            width: 100,
            child: FloatingActionButton(


              onPressed: () {
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>ElectionInputFlow()));
                // Show the add campaign dialog
              },
              tooltip: 'Add election',
              backgroundColor: Colors.red,
              child: Text("Delete",style: TextStyle(fontSize: 18)),
            ),
          ),

        ],
      ),



    );
  }
}