

import 'package:e_voting/pages/NEBE/announcement_list.dart';
import 'package:e_voting/pages/NEBE/constituencies_list.dart';

//import 'package:e_voting/pages/NEBE/home_page.dart';
import 'package:e_voting/pages/NEBE/political_party_list.dart';
import 'package:e_voting/pages/NEBE/poll.dart';
//import 'package:e_voting/pages/NEBE/polling_station_list.dart';
import 'package:e_voting/pages/NEBE/schedule_list.dart';
import 'package:e_voting/pages/constituencies/View_dispute.dart';
import 'package:e_voting/pages/constituencies/candidates_list.dart';
import 'package:e_voting/pages/constituencies/elections.dart';
import 'package:e_voting/pages/constituencies/news.dart';
import 'package:e_voting/pages/constituencies/polling_station.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/political_party/news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class constituencyNavbarss extends StatelessWidget {
  const constituencyNavbarss({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(accountName: Text("constituency"), accountEmail: Text("constituency@gmail.com")
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

             // Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text("News"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>conAnnouncementList()));
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.engineering),
            title: Text("candidates"),

            onTap: () {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>candidatesList()));
    },
          ),ListTile(
            leading: Icon(Icons.report),
            title: Text("disputes"),
            //
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>viewdispute()));
            },
          ),
          ListTile(
              leading: Icon(Icons.flag),
              title: Text("polling station"),

              onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>PollingStationList()));
              }
          ),
          ListTile(
            leading: Icon(Icons.poll),
            title: Text("Elections"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>elections()));
            },
          ),

      //    ListTile(
       //     leading: Icon(Icons.schedule),
      //      title: Text("Schedule"),
      //      onTap: (){
            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ScheduleList()));
       //     },
        //  ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: ()=>null,
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
