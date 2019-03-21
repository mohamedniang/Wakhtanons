import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "wakhtanons",
      home: Chat(),
    );
  }
}

class Chat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatWindow();
  }
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = TextEditingController();
  bool _isWritting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wakhtanons"),
      ),
      body: Column(
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
    );
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
                  onPressed: _isWritting
                      ? () => _submitMessage(_textController.text)
                      : null,
                ))
          ],
        ),
        // decoration: BoxDecoration(
        //   border: Border(
        //     top: BorderSide(
        //       color: Colors.brown[200],
        //     ),
        //   ),
        // ),
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
  @override
  void dispose(){
    for(Msg message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 165.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Souhaibou",
                  style: Theme.of(context).textTheme.subhead,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 0.0,
                    ),
                    child: Text(txt),
                  ),
                ],

              ),
            ),
            Expanded(
              child:CircleAvatar(
                child: Text("S"),
              ), 

            ),
          ],
        ),
      ),
    );
  }
}
