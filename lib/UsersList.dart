import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wakhtanons/classes/UserCard.dart';

class UsersList extends StatefulWidget {
  final DocumentSnapshot user;
  UsersList(this.user);
  @override
  State<StatefulWidget> createState() {
    return _UserListState();
  }
}

class _UserListState extends State<UsersList>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: StreamBuilder(
        stream: Firestore.instance.collection('utilisateurs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            ));
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                (snapshot.data.documents[index]['pseudo'] != "null" &&
                        snapshot.data.documents[index]['pseudo'] != widget.user.data['pseudo'])
                    ? UserCard(snapshot.data.documents[index], widget.user)
                    : null,
          );
        },
      ),
    );
  }
}
