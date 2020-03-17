

import 'package:example_app/model/auth.dart';
import 'package:example_app/screen/userlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TopPage extends StatelessWidget {
  Future<FirebaseUser> user;

  @override
  Widget build(BuildContext context) {

    user = GoogleAuth().handleSignIn();
    user.then((user) =>
    user == null ? Navigator.pushReplacementNamed(context, '/login') :
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserList(currentUser: user)))
    );

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
}