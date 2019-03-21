import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Cecie est juste un teste pour voir est-ce que les changement s'applique sur la branche principale
// git add *
// git push -u master

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Widget _buildListItem(BuildContext ctx, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['nom'],
              style: Theme.of(context).textTheme.headline,
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
              style: Theme.of(context).textTheme.display1,
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
          DocumentSnapshot nouveauSnap = await transaction.get(document.reference);
          await transaction.update(nouveauSnap.reference, {
            'aime': nouveauSnap['aime'] + 1
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "test",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Ladder of upvoted girl"),
          ),
          body: StreamBuilder(
            stream: Firestore.instance.collection('ladder').snapshots(),
            builder: (context, snapshot) {
              print(snapshot);
              if (!snapshot.hasData)
                return const Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Loading ...'),
                ));
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]),
              );
            },
          )),
    );
  }
}
