
import 'package:example_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  User user;

  Profile({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('プロフィール')),
      body: _Body(user: user),
    );
  }
}

class _Body extends StatelessWidget {
  User user;

  _Body({@required this.user});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserModel>(context);
    return FutureBuilder(
        future: userProvider.getCurrentUserInfo(user),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Container(
                  padding: EdgeInsets.all(100),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      image: DecorationImage(
                        image: NetworkImage(user.photoUrl),
                        fit: BoxFit.contain,
                      )),
                ),
                element('名前', 'displayName',snapshot,context),
                Divider(),
                element('メールアドレス', 'email',snapshot,context),
                Divider(),
                element('電話番号', 'phoneNumber', snapshot,context),
                Divider(),
                element('支店', '',snapshot,context),
                Divider(),
                    element('コメント', 'comment',snapshot,context),
                    Divider(),
                  ]));
        });
  }

  Widget element(String title, String content, AsyncSnapshot snapshot,context) {
    return GestureDetector(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 5),
          child: Text(
            title,
            style: TextStyle(fontSize: 17),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, bottom: 10),
          child:
               Text(snapshot.data[content] ?? 'なし' , style: TextStyle(fontSize: 15, color: Colors.blue)),
        ),
      ],
    ),
      onTap: (){
          User currentUser = User.fromMap(snapshot.data.data,snapshot.data.documentID);
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(user: currentUser, content: content, title: title,)));
      },
        );
  }
}

class EditProfile extends StatelessWidget {
  String content;
  String title;
  User user;

  EditProfile({@required this.content, this.user, this.title});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserModel>(context);
    final textController = TextEditingController();
    Map userMap = user.toJson();
    textController.text = userMap[content];
    return Scaffold(
      appBar: AppBar(title: Text(title + '変更')),
      body: Container(
        padding: EdgeInsets.only(top:70,left: 20,right: 30),
        child: Column(
          children: [
            TextFormField(
              controller: textController,
              autofocus: true,
            ),
            Container(
              padding: EdgeInsets.all(8)
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('保存'),
                onPressed: (){
                  userMap[content] = textController.text;
                  userProvider.updateUserProfile(userMap, userMap['id']);
                  Navigator.pop(context);
                },
              )
              )
          ],
        ),
      ),
    );
  }
}
