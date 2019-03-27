import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wakhtanons/classes/UserCard.dart';

class UsersList extends StatefulWidget {
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
        stream: Firestore.instance
        .collection('utilisateurs')
        .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ));
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                UserCard(snapshot.data.documents[index]),
          );
        },
      ),
    );
  }
}

// child: ListView.builder(
//         itemExtent: 80.0,
//         itemCount: response.documents.length,
//         itemBuilder: (context, index) => Card(
//               child: Text("data"),
//             ),
//       ),
