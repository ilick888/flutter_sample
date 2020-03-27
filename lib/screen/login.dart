import 'package:example_app/model/auth.dart';
import 'package:example_app/model/user.dart';
import 'package:example_app/screen/userlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyLogin extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final FirebaseMessaging _fcm = FirebaseMessaging();
            _fcm.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
            print("onResume: $message");
        },
      );

    return Scaffold(
      body: FrontBody(),
    );
  }
}

class FrontBody extends StatelessWidget {
  FirebaseUser firebaseUser;
  User user;

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context);

    return Container(
        color: Colors.blue[200],
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'アプリを利用するには\nログインが必要です',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              padding: EdgeInsets.all(20),
              child: Text('Googleログイン', style: TextStyle(fontSize: 20),),
              color: Colors.white,
              onPressed: () async{
                user = await GoogleAuth().handleSignIn();
                if(user == null){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('ログインしてください')));
                }else{
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserList(currentUser: user)));
                }
              },
              shape: StadiumBorder(),
            ),
          ],
        )
        )
    );
  }
}


