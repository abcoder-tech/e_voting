

import 'package:e_voting/pages/NEBE/announcement_list.dart';
import 'package:e_voting/pages/NEBE/constituencies_list.dart';
import 'package:e_voting/pages/NEBE/dispute_list.dart';
import 'package:e_voting/pages/NEBE/election_page.dart';
import 'package:e_voting/pages/NEBE/face.dart';
import 'package:e_voting/pages/NEBE/home_page.dart';
import 'package:e_voting/pages/NEBE/political_party_list.dart';
import 'package:e_voting/pages/NEBE/poll.dart';
import 'package:e_voting/pages/NEBE/polling_station_list.dart';
import 'package:e_voting/pages/NEBE/polling_station_view.dart';
import 'package:e_voting/pages/NEBE/schedule_list.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Navbarss extends StatelessWidget {
  const Navbarss({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
child: ListView(
  padding: EdgeInsets.zero,
  children: [
    UserAccountsDrawerHeader(accountName: Text("NEBE"), accountEmail: Text("NEBE@gmail.com")
    ,currentAccountPicture: CircleAvatar(
        child: ClipOval(
          child: Image.asset('lib/images/nebe.jpg',
          fit: BoxFit.cover,),
        ),
      ),
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage('lib/images/back.jpg'),
          fit: BoxFit.cover)
    ),
    ),
    ListTile(
      leading: Icon(Icons.home),
      title: Text("Home"),
      onTap: () {

        Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
      },
    ),
    ListTile(
      leading: Icon(Icons.post_add),
      title: Text("News"),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AnnouncementList()));
      },
    ),
    Divider(),
   /// ListTile(
      //leading: Icon(Icons.group),
      //title: Text("Political Party"),
      //onTap: () {
       // Navigator.push(context, MaterialPageRoute(builder: (context)=>PoliticalPartyList()));
      //},
   // ),
    //ListTile(
      //leading: Icon(Icons.maps_home_work_sharp),
      //title: Text("constituencies"),
      //
      //onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>ConstituencyList()));
      //},
    //),
    //ListTile(
      //  leading: Icon(Icons.flag),
        //title: Text("polling station"),

        //onTap: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>PollingStationList()));
        //}
    //),
    ListTile(
      leading: Icon(Icons.poll),
      title: Text("Elections"),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>elections()));
      },
    ),


    ListTile(
      leading: Icon(Icons.warning),
      title: Text("Disputes"),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>viewdisputee()));

      },
    ),
    Divider(),
    ListTile(
      leading: Icon(Icons.settings),
      title: Text("Settings"),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraCapturePage()));

      },
    ),
    Divider(),

    ListTile(
      leading: Icon(Icons.logout),
      title: Text("Logout"),
      onTap: (){
        QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          text: "Are you sure you want to Logout?",
          confirmBtnText: "Yes",
          cancelBtnText: "Cancel",
          onConfirmBtnTap: () async {
            await  Navigator.push(context, MaterialPageRoute(builder: (context)=>loginPage()));
            Navigator.pop(context);
          },
          onCancelBtnTap: () {
            Navigator.pop(context);
          },
        );

      },
    ),

  ],
),
    );
  }
}
