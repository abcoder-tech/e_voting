
import 'package:e_voting/pages/NEBE/political_party_list.dart';

import 'package:e_voting/pages/NEBE/polling_station_list.dart';
import 'package:e_voting/pages/NEBE/schedule_list.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/polling_station/View_dispute.dart';
import 'package:e_voting/pages/polling_station/elections.dart';
import 'package:e_voting/pages/polling_station/news.dart';
import 'package:e_voting/pages/polling_station/voters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class pollingstationNavbarss extends StatelessWidget {
  const pollingstationNavbarss({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(accountName: Text("polling station"), accountEmail: Text("pollingstation@gmail.com")
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
            leading: Icon(Icons.people),
            title: Text("voters"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>VotersList()));
            },
          ),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text("News"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>coonAnnouncementList()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.report),
            title: Text("disputes"),
            //
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>viewdispute()));
            },
          ),

          ListTile(
            leading: Icon(Icons.poll),
            title: Text("Elections"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>elections()));
            },
          ),


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
