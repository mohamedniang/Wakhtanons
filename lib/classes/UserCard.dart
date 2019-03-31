import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wakhtanons/ChatRoom.dart';

class UserCard extends StatelessWidget {
  DocumentSnapshot doc;
  DocumentSnapshot docTapper;
  String firstLetter, username;
  UserCard(this.doc, this.docTapper) {
    firstLetter = doc['pseudo'][0];
    username = doc['pseudo'];
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () => _chat(context),
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
      ),
    );
  }
  _chat(BuildContext ctx){
    // print('${doc.data.values}');
    // print('${doc.documentID}');
    // print('${docTapper.data.values}');
    // print('${docTapper.documentID}');
    Navigator.push(ctx, MaterialPageRoute(
      builder: (ctx) => ChatRoom(userEm: docTapper, userRc: doc,),
    ));
  }
}
