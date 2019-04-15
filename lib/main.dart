import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:wakhtanons/GlobalMessages.dart';
import 'package:wakhtanons/UsersList.dart';
import 'package:wakhtanons/setting.dart';
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

  //Construction de la page (assemblage des differents widget crée)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wakhtanons",
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Wakhtanons"),
            actions: <Widget>[
              // IconButton(
              //   icon: Icon(Icons.refresh),
              //   onPressed: null,
              // ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Settings(widget.userinfos),
                      ));
                },
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
              UsersList(widget.userinfos),
              GlobalMessages(widget.userinfos),
              Classement(widget.userinfos),
            ],
          )),
    );
  }
}
