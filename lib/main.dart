import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "test",
      home: Scaffold(
        appBar: AppBar(
          title: Text("app bar"),
        ),
        body: Center(
          child: FlatButton(
            child: Text("button"),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
