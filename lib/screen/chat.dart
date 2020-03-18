import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/model/message.dart';
import 'package:example_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  final textController = TextEditingController();
  User user;
  FirebaseUser currentUser;
  List<Message> messages;

  Chat({this.user, this.currentUser});

  @override
  Widget build(BuildContext context) {
    print('to:' + user.displayName);
    print('currentUser:' + currentUser.displayName);
    final MessageModel messageModel = Provider.of<MessageModel>(context);

    return Scaffold(
        appBar: AppBar(title: Text('To ' + user.displayName)),
        body: Padding(
          child: Column(children: [
            Expanded(
                child: ChatList(
              user: user,
              currentUser: currentUser,
            )),
            bottom(messageModel)
          ]),
          padding: EdgeInsets.all(10),
        ));
  }

  Widget bottom(MessageModel messageModel) {
    return Stack(children: <Widget>[
      Container(
          decoration: BoxDecoration(color: Colors.white),
          padding:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
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
                    textController
                      ..clearComposing()
                      ..clear();
                  },
                  child: Text('送信'),
                ),
              ),
            ],
          )),
    ]);
  }
}

class ChatList extends StatelessWidget {
  final User user;
  final FirebaseUser currentUser;
  List<Message> messages;

  ChatList({@required this.user, @required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final MessageModel messageModel = Provider.of<MessageModel>(context);
    return StreamBuilder(
      stream: messageModel.fetchMessagesAsStreamOrderByCreatedAt(
          user.uid, currentUser.uid),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        messages = snapshot.data.documents
            .map((doc) => Message.fromMap(doc.data, doc.documentID))
            .toList();
        return ListView(
          reverse: true,
          children: messages
              .map((f) => f.member.contains(user.uid) &&
              f.member.contains(currentUser.uid)
              ? Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    child: f.from != currentUser.uid
                        ? ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(100)),
                      child: Image.network(user.photoUrl),
                    )
                        : null,
                  ),
                  title: Bubble(
                    alignment: f.from != currentUser.uid
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: InkWell(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(f.message,
                              style: TextStyle(fontSize: 17)),
                        ),
                        onLongPress: () async{
                          await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: Text('本当に削除しますか'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('いいえ'),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('はい'),
                                      onPressed: (){
                                        messageModel.removeMessage(f.id);
                                        Navigator.of(context).pop();
                                      },
                                    ),

                                  ],
                                );
                              }
                          );
                        }
                    ),
                    nip: f.from != currentUser.uid
                        ? BubbleNip.leftTop
                        : BubbleNip.rightTop,
                  )))
              : Container())
              .toList(),
        );
      },
    );
  }
}

