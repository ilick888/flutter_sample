
import 'package:flutter/material.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: FrontBody(),
    );
  }
}

class FrontBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(40),
        color: Colors.white30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ログインイメージ', style: Theme.of(context).textTheme.display1,),
          Container(
            height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Username'
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Password'
              ),
            ),
            Container(
              height: 20,
            ),
            RaisedButton(
              color: Colors.red[200],
              child: Container(
                padding: EdgeInsets.only(right: 100, left: 100),
                child: Text('ログイン', style: TextStyle(fontSize: 12),),
              ),
              onPressed: (){Navigator.pushReplacementNamed(context, '/todoList');},
              shape: StadiumBorder(),
            )
          ],
        )
      ),
    );
  }
}

