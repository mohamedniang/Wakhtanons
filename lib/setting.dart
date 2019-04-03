import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final DocumentSnapshot user;
  Settings(this.user);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final String url =
      "https://firebasestorage.googleapis.com/v0/b/wakhtanons-2981a.appspot.com/o/IMG_2844.JPG?alt=media&token=88cfb6d8-38a0-480e-b9e4-572cb355ffa8";

  final _formKey = GlobalKey();

  Widget _input({IconData ico, String hintText, String oldValue}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          // Icon(ico),
          Expanded(
            child: TextFormField(
              initialValue: "$oldValue",
              style: TextStyle(color: Theme.of(context).accentColor),
              decoration: InputDecoration(
                icon: Icon(ico),
                hintText: "$hintText",
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Setting',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _input(
                      ico: Icons.person,
                      hintText: "username",
                      oldValue: widget.user['pseudo'] ?? ""),
                  _input(
                      ico: Icons.lock,
                      hintText: "password",
                      oldValue: widget.user['motdepasse'] ?? ""),
                  _input(
                      ico: Icons.lock_outline,
                      hintText: "repeat password",
                      oldValue: widget.user['motdepasse'] ?? ""),
                  _input(
                      ico: Icons.mail,
                      hintText: "email",
                      oldValue: widget.user['email'] ?? ""),
                  _input(
                      ico: Icons.call,
                      hintText: "tel",
                      oldValue: widget.user['tel'] ?? ""),
                ],
              ),
            ),
          ),
        ));
  }
}
