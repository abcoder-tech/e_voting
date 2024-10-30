import 'package:e_voting/pages/announcement_list.dart';
import 'package:e_voting/pages/announcements.dart';
import 'package:e_voting/pages/home_page.dart';
import 'package:e_voting/pages/loginpage.dart';
import 'package:e_voting/pages/nebe_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      title: Text("Announcments"),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>announcementlist()));
      },
    ),
    Divider(),
    ListTile(
      leading: Icon(Icons.group),
      title: Text("Political Party"),
      onTap: ()=>null,
    ),
    ListTile(
      leading: Icon(Icons.how_to_vote_outlined),
      title: Text("voter"),
      onTap: ()=>null,
    ),ListTile(
      leading: Icon(Icons.maps_home_work_sharp),
      title: Text("regional office"),
      onTap: ()=>null,
    ),
    ListTile(
      leading: Icon(Icons.ballot),
      title: Text("Ballots"),
      onTap: ()=>null,
    ),
    Divider(),
    ListTile(
      leading: Icon(Icons.settings),
      title: Text("Settings"),
      onTap: ()=>null,
    ),
    Divider(),
    SizedBox(height: 70,),
    ListTile(
      leading: Icon(Icons.logout),
      title: Text("Logout"),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>loginPage()));
      },
    ),

  ],
),
    );
  }
}
