import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './classes/Msg.dart';
import './Classement.dart';
import './Intro.dart';

// Cecie est juste un teste pour voir est-ce que les changement s'applique sur la branche principale
// git add *
// git push -u master

void main() => runApp(Intro());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  // déclaration des variables
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = TextEditingController();
  bool _isWritting = false;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (Msg message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  Widget _buildComposer(DocumentReference doc) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 9.0,
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String txt) {
                  setState(() {
                    _isWritting = txt.length > 0;
                  });
                },
                // onSubmitted: _submitMessage,
                decoration: InputDecoration.collapsed(
                  hintText: "Entrez votre message ici",
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 3.0,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                  ),
                  onPressed: () {
                    if (_isWritting) {
                      print(_textController.text);
                      return _submitMessage(_textController.text, doc);
                    } else {
                      return null;
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }

  void _submitMessage(String txt, DocumentReference document) {
    _textController.clear();
    print(DateTime.now().millisecondsSinceEpoch.toString());
    setState(() {
      _isWritting = false;
    });
    // Msg message = new Msg(
    //   txt: txt,
    //   animationController: AnimationController(
    //     vsync: this,
    //     duration: Duration(
    //       milliseconds: 800,
    //     ),
    //   ),
    // );
    setState(() {
      // _messages.insert(0, message);
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(document,
            {'txt': txt, 'timestamp': DateTime.now().millisecondsSinceEpoch});
      });
      // document.setData({'txt': txt});
    });
    // message.animationController.forward();
  }

  //Construction de la page (assemblage des differents widget crée)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wakhtanons",
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Wakhtanons"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: null,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: null,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: <Tab>[
                Tab(
                  icon: Icon(Icons.message),
                  text: "Messages",
                ),
                Tab(
                  icon: Icon(Icons.list),
                  text: "Classement",
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Entrez le nom du destinataire",
                    ),
                  ),
                  Flexible(
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          var res = snapshot.data
                              .documents; // variable qui vas contenir la table "message"
                          // print("taille = " + res.length.toString());
                          if (!snapshot.hasData)
                            return const Center(
                                child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.red),
                            ));
                          return ListView.builder(
                            reverse: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(10.0),
                            itemExtent: 80.0,
                            itemCount: res.length,
                            itemBuilder: (context, index) {
                              return Msg(
                                txt: res[index]['txt'],
                                animationController: AnimationController(
                                  vsync: this,
                                  duration: Duration(
                                    milliseconds: 800,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  ),
                  Divider(
                    height: 1.0,
                    color: Colors.blue[300],
                  ),
                  Container(
                    child: _buildComposer(
                        Firestore.instance.collection('messages').document()),
                  ),
                ],
              ),
              Classement(),
            ],
          )),
    );
  }
}
