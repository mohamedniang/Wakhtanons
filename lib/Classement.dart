import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Classement extends StatefulWidget {
  DocumentSnapshot currentUser;
  Classement(this.currentUser);
  @override
  State<StatefulWidget> createState() {
    return _ClassementState();
  }
}

class _ClassementState extends State<Classement>
    with SingleTickerProviderStateMixin {
  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('ladder').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ));
        return ListView.builder(
          // itemExtent: 80.0,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildCandidat(context, snapshot.data.documents[index]),
        );
      },
    );
  }

  Widget _buildCandidat(BuildContext ctx, DocumentSnapshot document) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.network(
            'https://firebasestorage.googleapis.com/v0/b/wakhtanons-2981a.appspot.com/o/IMG_2844.JPG?alt=media&token=88cfb6d8-38a0-480e-b9e4-572cb355ffa8',
            height: 150.0,
            width: 150.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                icon: Icon(Icons.thumb_up),
                label: Text("${document.data['like']}"),
                onPressed: () => _liked(document),
              ),
              RaisedButton.icon(
                icon: Icon(Icons.thumb_down),
                label: Text("${document.data['dislike']}"),
                onPressed: () => _disliked(document),
              ),
            ],
          )
        ],
      ),
    );
  }
  _liked(DocumentSnapshot document) async {
    var res = await Firestore.instance.collection('ladder').document('alreadyVoted');
    if(res != null){
      print(res.path);
    }else{
      print("nothing");

    }
    Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot nouveauSnap =
              await transaction.get(document.reference);
          await transaction
              .update(nouveauSnap.reference, {'like': nouveauSnap['like'] + 1});
        });
  }
  _disliked(DocumentSnapshot document) {
    Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot nouveauSnap =
              await transaction.get(document.reference);
          await transaction
              .update(nouveauSnap.reference, {'dislike': nouveauSnap['dislike'] + 1});
        });
  }
}

