
import 'package:example_app/model/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: FrontBody(),
    );
  }
}

class FrontBody extends StatelessWidget {
  Future<FirebaseUser> user;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        padding: EdgeInsets.all(40),
        color: Colors.white30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.blue[200],
              child: Container(
                padding: EdgeInsets.only(right: 100, left: 100),
                child: Text('Google SignIn', style: TextStyle(fontSize: 12),),
              ),
              onPressed: (){
                user = Future.value(googleAuth().handleSignIn());
                user.then((user) => 
                  user == null ?  Scaffold.of(context).showSnackBar(SnackBar(content: Text('please login'))) : Navigator.pushNamed(context, '/todoList')
                );
                },
              shape: StadiumBorder(),
            )
          ],
        )
      ),
    );
  }
}

