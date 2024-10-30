import 'package:e_voting/components/mybotton.dart';
import 'package:e_voting/components/mytextfiled.dart';
import 'package:e_voting/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class loginPage extends StatelessWidget {

   loginPage({super.key});
final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  void signUserIn(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [

                      Color(0xff2193b0),
                      Color(0xff6dd5ed)
                    ] )
            ),


            child: Padding(
              padding: EdgeInsets.only(top: 60,left: 22,),
              child: Text("Hello\nSign in!",style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),


















            ),
          ),
          Padding(padding:
          EdgeInsets.only(top: 200),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),

              ),
              color: Colors.white
            ),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mytextfiled(hinttext: "Enter Username", obscuretext: false,controller: usernamecontroller, labeel: 'User Id', icoon: Icon(Icons.check),),
                //const SizedBox(height: 25,),
                mytextfiled(obscuretext: true,hinttext: "Enter Password",controller: passwordcontroller,labeel: 'Password', icoon: Icon(Icons.visibility_off),),
                const SizedBox(height: 20,)
                ,
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forget Password?",style:
                      TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xff281537),),
                  )),
                ),
                const SizedBox(height: 70,),
                mybotton(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
                  }, butttontext: 'Sign In',
                ),
                const SizedBox(height: 100,),
              ],
            ),
          ),)
        ],
      )

    );
  }
}
