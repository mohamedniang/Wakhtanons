import 'package:flutter/material.dart';


import './classes/Msg.dart';
import './Classement.dart';

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
    for(Msg message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }

  Widget _buildComposer() {
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
                onSubmitted: _submitMessage,
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
                      return _submitMessage(_textController.text);
                    }
                    else {
                      return null;
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
  
  void _submitMessage(String txt) {
    _textController.clear();
    setState(() {
      _isWritting = false;
    });
    Msg message = new Msg(
      txt:txt,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 800,
        ),
      ),
    );
    setState(() {
     _messages.insert(0,message); 
    });
    message.animationController.forward();
  }
  

  //Construction de la page (assemblage des differents widget crée)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wakhtanons",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Wakhtanons"),
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
                    child: ListView.builder(
                      itemBuilder: (_, int index) {
                        return _messages[index];
                      },
                      itemCount: _messages.length,
                      reverse: true,
                      padding: EdgeInsets.all(6.0),
                    ),
                  ),
                  Divider(
                    height: 1.0,
                  ),
                  Container(
                    child: _buildComposer(),
                  ),
                ],
              ),
              Classement(),
            ],
          )),
    );
  }
}