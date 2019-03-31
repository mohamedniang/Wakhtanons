import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wakhtanons/classes/BuildComposer.dart';
import 'package:wakhtanons/classes/Msg.dart';

class GlobalMessages extends StatefulWidget {
  GlobalMessages(this.userinfos);
  DocumentSnapshot userinfos;
  @override
  _GlobalMessagesState createState() => _GlobalMessagesState();
}

class _GlobalMessagesState extends State<GlobalMessages>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // print("taille = " + res.length.toString());
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ));
                  } else {
                    var res = snapshot.data
                        .documents; // variable qui vas contenir la table "message"
                    return ListView.builder(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(10.0),
                      itemExtent: 80.0,
                      itemCount: res.length,
                      itemBuilder: (context, index) {
                        return Msg(
                          txt: res[index]['txt'],
                          sender: res[index]['from'] ?? 'unknown',
                          animationController: AnimationController(
                            vsync: this,
                            duration: Duration(
                              milliseconds: 800,
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
          Divider(
            height: 1.0,
            color: Colors.blue[300],
          ),
          Container(
            child: BuildComposer(
                doc: Firestore.instance.collection('messages').document(),
                type: 1,
                from: widget.userinfos
                ),
          ),
        ],
      ),
    );
  }
}
