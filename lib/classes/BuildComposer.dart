import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildComposer extends StatefulWidget {
  BuildComposer({this.doc, this.type = 0, this.from});

  final DocumentReference doc;
  final DocumentSnapshot from;
  final int type;

  @override
  _BuildComposerState createState() => _BuildComposerState();
}

class _BuildComposerState extends State<BuildComposer> {
  final TextEditingController _textController = TextEditingController();

  bool _isWritting = false;

  void _submitMessage(String txt, DocumentReference document) {
    _textController.clear();
    setState(() {
      _isWritting = false;
    });

    setState(() {
      if (widget.type == 0) {
        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(document, {
            'content': txt,
            'from': widget.from.data['pseudo'].toString(),
            'timestamp': DateTime.now().millisecondsSinceEpoch
          });
        });
      } else if (widget.type == 1) {
        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(document,
              {
                'txt': txt, 
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'from': widget.from.data['pseudo'].toString()
                });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onSubmitted: (input) =>
                    _submitMessage(_textController.text, widget.doc),
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
                      return _submitMessage(_textController.text, widget.doc);
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
}
