import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/model/message.dart';
import 'package:example_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Chat extends StatelessWidget {
  final textController = TextEditingController();
  User user;
  User currentUser;
  List<Message> messages;

  Chat({this.user, this.currentUser});

  @override
  Widget build(BuildContext context) {
    print('to:' + user.displayName);
    print('currentUser:' + currentUser.displayName);
    final MessageModel messageModel = Provider.of<MessageModel>(context);

    return Scaffold(
        appBar: AppBar(title: Text('To ' + user.displayName)),
        body: Container(
          child: GestureDetector(
            onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
            child : Column(children: [
            Expanded(
                child: ChatList(
              user: user,
              currentUser: currentUser,
            )),
            bottom(messageModel,context)
          ]),
        )));
  }

  Widget bottom(MessageModel messageModel,BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          decoration: BoxDecoration(color: Colors.white),
          padding:
              EdgeInsets.only(top: 10.0, bottom: 20.0, left: 15.0, right: 15.0),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 14,
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                    )
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 3,
                child: FlatButton(
                  padding: EdgeInsets.all(15.0),
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
                  child: Text('送信', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11)),
                ),
              ),
            ],
          )),
    ]);
  }
}

// ignore: must_be_immutable
class ChatList extends StatelessWidget {
  final User user;
  final User currentUser;
  List<Message> messages;

  ChatList({@required this.user, @required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final MessageModel messageModel = Provider.of<MessageModel>(context);
    var formatter = new DateFormat('M月d日 HH:mm');
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
                  subtitle: Container(
                    alignment: f.from != currentUser.uid ? Alignment(-0.9,0) : Alignment(0.9,0),
                    padding: EdgeInsets.only(top: 1),
                      child: Text(formatter.format(f.createdAt)),
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
                        onLongPress: (){showDelete(context,messageModel,f);}
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

  Future<Widget> showDelete(context,messageModel,Message f) async{
    return                          await showDialog(
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
}


