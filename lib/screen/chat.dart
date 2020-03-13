import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/model/message.dart';
import 'package:example_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  final textController = TextEditingController();
  final User user;
  final FirebaseUser currentUser;
  List<Message> messages;

  Chat({Key key, this.user, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MessageModel messageModel = Provider.of<MessageModel>(context);

    return Scaffold(
        appBar: AppBar(title: Text('To ' + user.displayName)),
        body: Padding(
          child: Column(children: [
            Expanded(child: content(context, messageModel)),
            bottom(messageModel)
          ]
              //content(context,messageModel)
              ),
          padding: EdgeInsets.all(10),
        ));
  }

  Widget content(context, MessageModel messageModel) {
    return StreamBuilder(
      stream: messageModel.fetchMessagesAsStreamOrderByCreatedAt(
          user.uid, currentUser.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data.documents == null) {
          return CircularProgressIndicator();
        }
        messages = snapshot.data.documents
            .map((doc) => Message.fromMap(doc.data, doc.documentID))
            .toList();
        return ListView(
          reverse: true,
          children: messages
              .map((f) => Card(
                  child: f.member.contains(user.uid) &&
                          f.member.contains(currentUser.uid)
                      ? ListTile(
                          title: Text(f.message),
                          leading: f.from == currentUser.uid
                              ? Text('自分')
                              : Text(user.displayName))
                      : null))
              .toList(),
        );
      },
    );
  }

  Widget bottom(MessageModel messageModel) {
    return Stack(children: <Widget>[
      Container(
          decoration: BoxDecoration(color: Colors.white),
          padding:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 20.0),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 13,
                child: TextFormField(
                  controller: textController,
                ),
              ),
              Flexible(child: Container()),
              Flexible(
                flex: 3,
                child: FlatButton(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.blue,
                  onPressed: () {
                    if (textController.text != '') {
                      messageModel.createRecord(Message(
                          to: user.uid,
                          from: currentUser.uid,
                          message: textController.text));
                    }
                    textController..clearComposing()..clear();
                  },
                  child: Text('送信'),
                ),
              ),
            ],
          )),
    ]);
  }
}
