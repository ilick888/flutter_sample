
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'api.dart';

class User {
  String id;
  String uid;
  String displayName;
  String email;
  String phoneNumber;
  String photoUrl;
  DateTime createdAt;


  User({@required this.uid, this.createdAt, this.displayName, this.email, this.phoneNumber, this.photoUrl});

  User.fromMap(Map snapshot,String id) :
        id = id ?? '',
        uid = snapshot['uid'] ?? '',
        displayName = snapshot['displayName'] ?? '',
        email = snapshot['email'],
        phoneNumber = snapshot['phoneNumber'] ?? '',
        photoUrl = snapshot['photoUrl'] ?? '',
        createdAt = snapshot['createdAt'].toDate() ?? null;

  toJson() {
    return {
      "uid": uid,
      "displayName" : displayName,
      "email" : email,
      "phoneNumber" : phoneNumber,
      "photoUrl" : photoUrl,
      "createdAt": createdAt,
    };
  }
}

class UserModel extends ChangeNotifier{
  Api _api = Api('user');
  List<User> users;

  firstCreateRecord(FirebaseUser firebaseUser) async{
    User user = new User(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoUrl,
      createdAt: DateTime.now(),
    );
    final QuerySnapshot result = await Future.value(_api.getDataCollectionWhere(user.uid, 'uid'));
    result.documents.isEmpty ? _api.addDocument(user.toJson()) : print(result.documents[0]['uid']);
  }

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return _api.streamDataCollection();
  }

}