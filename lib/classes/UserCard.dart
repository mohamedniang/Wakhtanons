import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCard extends StatelessWidget {
  DocumentSnapshot doc;
  String firstLetter, username;
  UserCard(this.doc) {
    firstLetter = doc['pseudo'][0];
    username = doc['pseudo'];
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text('$firstLetter'),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Expanded(
              child: Text(                
                '$username',                
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
