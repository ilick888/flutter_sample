

import 'package:example_app/model/auth.dart';
import 'package:example_app/model/user.dart';
import 'package:example_app/screen/userlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TopPage extends StatelessWidget {
  FirebaseUser firebaseUser;
  User user;

  @override
  Widget build(BuildContext context) {

    login(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.blue[300]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Text('かばっぷ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50
                    )
                ),
              ),
              Container(
                  child: Image.asset('images/kaba.png', height: 180, width: 180,)
              )
            ],
          ),
        )
      )
    );
  }

  login(BuildContext context) async{
    user = await GoogleAuth().handleSignIn();
    if(user == null){
      Navigator.pushReplacementNamed(context, '/login');
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserList(currentUser: user)));
    }
  }
}