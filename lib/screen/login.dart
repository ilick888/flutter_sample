import 'package:example_app/model/auth.dart';
import 'package:example_app/screen/userlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FrontBody(),
      floatingActionButton: Bottom(),
    );
  }
}

class FrontBody extends StatelessWidget {
  Future<FirebaseUser> user;

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                user = GoogleAuth().handleSignIn();
                user.then((user) => user == null
                    ? Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('ログインしてください')))
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserList(currentUser: user))));
              },
              shape: StadiumBorder(),
            ),
          ],
        )
        )
    );
  }
}

class Bottom extends StatelessWidget {
  Future<FirebaseUser> user;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blue[200],
      child: Icon(Icons.add),
      onPressed: (){
        user = GoogleAuth().handleSignIn();
        user.then((user){
            user == null
                ? Scaffold.of(context).showSnackBar(SnackBar(content: Text('ログインしてください')))
            : Navigator.pushReplacement(context,MaterialPageRoute(
                builder: (context) =>
                    UserList(currentUser: user)
            )
            );
        }
        );
      },
    );
  }
}

