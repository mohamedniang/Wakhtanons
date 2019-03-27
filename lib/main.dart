import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:wakhtanons/GlobalMessages.dart';
import 'package:wakhtanons/UsersList.dart';
import './Classement.dart';
import './Intro.dart';

// Cecie est juste un teste pour voir est-ce que les changement s'applique sur la branche principale
// git add *
// git push -u master

void main() => runApp(Intro());

class MyApp extends StatefulWidget {
  final DocumentSnapshot userinfos;

  MyApp(this.userinfos);
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  // déclaration des variables
  MyAppState(){
    _greeting(context);
  }
  TabController _tabController;
  List<Tab> _myTabs = <Tab>[
    Tab(
      icon: Icon(Icons.person),
      text: "Conversation",
    ),
    Tab(
      icon: Icon(Icons.message),
      text: "Messages Public",
    ),
    Tab(
      icon: Icon(Icons.list),
      text: "Top Classement",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _greeting(BuildContext ctx) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bienvenue'),
          content: Text('Content de vous voir ${widget.userinfos['pseudo']}'),
          actions: <Widget>[
            FlatButton(
              child: Text('Continuer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              tabs: _myTabs,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              UsersList(),
              GlobalMessages(),
              Classement(),
            ],
          )),
    );
  }
}
