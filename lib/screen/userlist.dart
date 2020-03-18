import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/model/user.dart';
import 'package:example_app/screen/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:example_app/model/auth.dart';

import 'chat.dart';

class UserList extends StatelessWidget {
  final User currentUser;

  UserList({@required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('連絡先')),
      drawer: UserDrawer(
        currentUser: currentUser,
      ),
      body: body(context, currentUser),
    );
  }
}

List<User> users;

Widget body(context, currentUser) {
  final userProvider = Provider.of<UserModel>(context);
  return StreamBuilder(
    stream: userProvider.fetchUsersAsStream(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      users = snapshot.data.documents
          .map((doc) => User.fromMap(doc.data, doc.documentID))
          .toList();
      return ListView(
          children: users
              .map((f) => Container(
                  child: f.uid == currentUser.uid
                      ? null
                      : Card(
                          child: ListTile(
                          title: Text(f.displayName),
                          leading: Container(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Image.network(f.photoUrl),
                            ),
                          ),
                          trailing: f.phoneNumber != null
                              ? IconButton(
                                  icon: Icon(Icons.call),
                                  onPressed: () {
                                    _launchURL(f.phoneNumber);
                                  },
                                )
                              : null,
                          subtitle: Text(f.email),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chat(
                                        currentUser: currentUser, user: f)));
                          },
                        ))))
              .toList());
    },
  );
}

_launchURL(String phoneNumber) {
  launch('tel:' + phoneNumber);
}

class UserDrawer extends StatelessWidget {
  final User currentUser;
  String uid;

  UserDrawer({@required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserModel>(context);

    return Drawer(
        child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DrawerHeader(
                  child: ListTile(
                    title: Text(currentUser.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.black,
                        )
                    ),
                    subtitle: Text(currentUser.email),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                    image: DecorationImage(
                      image: NetworkImage(currentUser.photoUrl),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                  ListTile(
                    title: Text('プロフィール'),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(user: currentUser)));
                    },
                  ),
                Divider(),
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: ListTile(
                    title: Text('ログアウト(アプリ終了)'),
                    onTap: () async{
                      await GoogleAuth().signOutGoogle();
                      exit(0);
                    },
                  ),
                ),
                Divider()
              ],
            ),
        )
    );
  }

  void setMember(uid){
    this.uid = uid;
  }
}
