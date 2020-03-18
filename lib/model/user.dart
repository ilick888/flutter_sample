
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
        id = id,
        uid = snapshot['uid'] ?? '',
        displayName = snapshot['displayName'] ?? '',
        email = snapshot['email'] ?? '',
        phoneNumber = snapshot['phoneNumber'],
        photoUrl = snapshot['photoUrl'] ?? '',
        createdAt = snapshot['createdAt'].toDate() ?? null;

  toJson() {
    return {
      "id" : id,
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
  User user;

  Future<User> firstCreateRecord(FirebaseUser firebaseUser) async{
    user = new User(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoUrl,
      createdAt: DateTime.now(),
    );
    final QuerySnapshot result = await Future.value(_api.getDataCollectionWhere(user.uid, 'uid'));
    if(result.documents.isEmpty){
      await _api.addDocument(user.toJson());
    } else {
      DocumentSnapshot doc = await _api.getDocumentById(result.documents.first.documentID);
      user = User.fromMap(doc.data, doc.documentID);
      user.createdAt = DateTime.now();
      _api.updateDocument(user.toJson(), user.id);
      print(result.documents.first['uid']);
    }
    return user;
  }


  Stream<QuerySnapshot> fetchUsersAsStream() {
    return _api.streamDataCollection();
  }

  updateUser(FirebaseUser firebaseUser,User user) async{
    final QuerySnapshot result = await Future.value(_api.getDataCollectionWhere(firebaseUser.uid, 'uid'));
    final String docId = result.documents[0].documentID;
    _api.updateDocument(user.toJson(), docId);
  }
  updateUserProfile(Map user, String id) async{
    _api.updateDocument(user, id);
  }

  getCurrentUserInfo(User user) async{
    return await _api.getDocumentById(user.id);
  }
}