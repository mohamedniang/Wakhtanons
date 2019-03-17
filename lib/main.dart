import 'package:flutter/material.dart';

// Cecie est juste un teste pour voir est-ce que les changement s'applique sur la branche principale

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wakhtanons',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Wakhtanons !'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('hello start messaging now'),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter destination user',
                          ),
                        ),
                      ),
                      // Container(
                      //     child: Flexible(
                      //         child: ListView(
                      //           children: <Widget>[
                      //             const Text('I\'m dedicating every day to you'),
                      //             const Text('Domestic life was never quite my style'),
                      //             const Text(
                      //                 'When you smile, you knock me out, I fall apart'),
                      //             const Text('And I thought I was so smart'),
                      //           ],
                      // ))),
                      Container(
                        child: Row(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'enter your message here',
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.send),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
