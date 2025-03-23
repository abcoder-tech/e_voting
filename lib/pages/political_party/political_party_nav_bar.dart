

import 'package:e_voting/pages/NEBE/announcement_list.dart';
import 'package:e_voting/pages/NEBE/constituencies_list.dart';
import 'package:e_voting/pages/NEBE/home_page.dart';
import 'package:e_voting/pages/NEBE/political_party_list.dart';
import 'package:e_voting/pages/NEBE/poll.dart';
import 'package:e_voting/pages/NEBE/polling_station_list.dart';
import 'package:e_voting/pages/NEBE/schedule_list.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/political_party/candidate_view.dart';
import 'package:e_voting/pages/political_party/election_campaign_list.dart';
import 'package:e_voting/pages/political_party/elections.dart';
import 'package:e_voting/pages/political_party/news.dart';
import 'package:e_voting/pages/political_party/political_dispute.dart';
import 'package:e_voting/pages/political_party/schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class politicalpartyNavbarss extends StatelessWidget {
  const politicalpartyNavbarss({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(accountName: Text("political party"), accountEmail: Text("politicalparty@gmail.com")
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
            leading: Icon(Icons.campaign),
            title: Text("Election campaign"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>campaignList()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text("News"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>userAnnouncementList()));
            },
          ),

          ListTile(
            leading: Icon(Icons.engineering),
            title: Text("candidates"),
            onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>candidatesview()));
          },
          ),ListTile(
            leading: Icon(Icons.report),
            title: Text("disputes"),
            //
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>politicaldispute()));
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
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('userId');
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
