import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Classement extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClassementState();
  }
}

class _ClassementState extends State<Classement>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('ladder').snapshots(),
      builder: (context, snapshot) {
        print(snapshot);
        if (!snapshot.hasData)
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ));
        return ListView.builder(
          itemExtent: 80.0,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, snapshot.data.documents[index]),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext ctx, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['nom'],
              style: Theme.of(ctx).textTheme.headline,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green[100],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Text(
              document['aime'].toString(),
              style: Theme.of(ctx).textTheme.display1,
            ),
          )
        ],
      ),
      onTap: () {
        print("should increse votes here");
        // document.reference.updateData({
        //   'aime': document['aime'] + 1
        // });
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot nouveauSnap =
              await transaction.get(document.reference);
          await transaction
              .update(nouveauSnap.reference, {'aime': nouveauSnap['aime'] + 1});
        });
      },
    );
  }
}
