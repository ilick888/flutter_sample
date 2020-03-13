import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/model/auth.dart';
import 'package:example_app/model/todo.dart';
import 'package:example_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat.dart';

class UserList extends StatelessWidget {
  final FirebaseUser currentUser;

  UserList({Key key, @required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('I am ' + currentUser.displayName)),
      body: body(context,currentUser),
    );
  }
}

  List<User> users;

  Widget body(context,currentUser) {
    final userProvider = Provider.of<UserModel>(context);
    return StreamBuilder(
      stream: userProvider.fetchUsersAsStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.data.documents == null){return CircularProgressIndicator();}
        users = snapshot.data.documents.map((doc) => User.fromMap(doc.data, doc.documentID)).toList();
        return ListView(
            children: users.map((f) => Card(child: f.uid == currentUser.uid ? null :
            ListTile(
              title: Text(f.displayName),
              subtitle: Text(f.email),
              leading: Icon(Icons.account_circle),
              onTap: (){
                GoogleAuth().getCurrentUser();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Chat(currentUser: currentUser, user: f)
                ));
              },
            )
            )
            ).toList());
      },
    );
  }

class CurrentUser {

  String getCurrentUser(){
    FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(snapshot.data.toString());
      },
    );
  }
}

class ScreenArguments{
  final FirebaseUser currentUser;
  ScreenArguments(this.currentUser);

}