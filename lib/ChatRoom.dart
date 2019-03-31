import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wakhtanons/classes/BuildComposer.dart';
import 'package:wakhtanons/classes/Msg.dart';

class ChatRoom extends StatefulWidget {
  final DocumentSnapshot userEm;
  final DocumentSnapshot userRc;
  String chatRoomID;
  ChatRoom({this.userEm, this.userRc}) {
    // e4t1C3J5htYdnYAM9pw8--LavF-aaWE2mdKNs8JhX
    // -LavF-aaWE2mdKNs8JhX-e4t1C3J5htYdnYAM9pw8
    this.chatRoomID = userEm.documentID.hashCode >= userRc.documentID.hashCode
        ? userEm.documentID + '-' + userRc.documentID
        : userRc.documentID + '-' + userEm.documentID;
  }
  @override
  _ChatRoomState createState() => _ChatRoomState(this.chatRoomID);
}

class _ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  final String roomID;
  var test;
  _ChatRoomState(this.roomID);

  @override
  void initState() {
    super.initState();
    print(roomID);
    print("userEm:" + widget.userEm.documentID.hashCode.toString());
    print("userRc:" + widget.userRc.documentID.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userRc.data['pseudo']}'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('rooms')
                      .document(roomID)
                      .collection(roomID)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
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
                            txt: res[index]['content'],
                            sender: '${res[index]['from']}',
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
                doc: Firestore.instance
                    .collection('rooms')
                    .document(roomID)
                    .collection(roomID)
                    .document(),
                type: 0,
                from: widget.userEm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
