import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final DocumentSnapshot user;
  Settings(this.user);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
        body: Container(
          child: ListView.builder(
            itemExtent: 80.0,
            itemCount: widget.user.data.length,
            itemBuilder: (context, index) => Card(
                    child: Center(
                  child: Row(
                    children: <Widget>[
                      Text('${widget.user.data.keys.toList()[index]} : ',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                      ),
                      Text('${widget.user.data.values.toList()[index]}'),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
